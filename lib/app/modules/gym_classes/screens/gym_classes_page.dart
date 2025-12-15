import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/gym_class_repository.dart';
import 'package:gym_app/app/modules/gym_classes/bloc/gymClass_bloc.dart';
import 'package:gym_app/app/modules/gym_classes/screens/gym_class_detail_page.dart';
import 'package:gym_app/app/widgets/storage_network_image.dart';
import 'package:intl/intl.dart';

class GymClassesPage extends StatelessWidget {
  const GymClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GymClassBloc(
        gymclassRepository: GymclassRepository()
      )..add(LoadGymClasses()),
      child: const GymClassView(),
    );
  }
}

class GymClassView extends StatelessWidget {
  const GymClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      appBar: AppBar(
        title: const Text('Gym Classes', style: TextStyle(fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black.withOpacity(0.05),
            height: 1,
          ),
        ),
      ),
      body: BlocConsumer<GymClassBloc, Object>(
        listener: (context, state) {
          if (state is GymClassError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is GymClassLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GymClassesLoaded) {
            if (state.gymClasses.isEmpty) {
              return const Center(
                child: Text('No gym classes available'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<GymClassBloc>().add(LoadGymClasses());
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildClassCard(context, state.gymClasses[index]),
                        childCount: state.gymClasses.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        
          return const Center(child: Text('No Gym Classes Available'));
        },
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, dynamic gymClass) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GymClassDetailPage(
                  classId: gymClass.id,
                  className: gymClass.name,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: StorageNetworkImage(
                    imagePath: gymClass.images,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: const Color(0xFFF4F4F5),
                      child: const Icon(Icons.fitness_center, size: 40, color: Color(0xFF71717A)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gymClass.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF18181B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(gymClass.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: gymClass.status == 'active' ? const Color(0xFFDCFCE7) : const Color(0xFFF4F4F5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        gymClass.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: gymClass.status == 'active' ? const Color(0xFF16A34A) : const Color(0xFF71717A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

