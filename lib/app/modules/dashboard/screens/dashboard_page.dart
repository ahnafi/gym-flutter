import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/dashboard_repository.dart';
import 'package:gym_app/app/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:gym_app/app/widgets/storage_network_image.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        dashboardRepository: DashboardRepository(),
      )..add(LoadDashboard()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
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
      body: BlocBuilder<DashboardBloc, Object>(
        builder: (context, dashboardState) {
          if (dashboardState is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dashboardState is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(dashboardState.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardBloc>().add(LoadDashboard()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (dashboardState is DashboardLoaded) {
            final summary = dashboardState.summary;
            final data = dashboardState.data;
            final user = data['user'];
            final currentMembership = summary['currentMembership'];
            final currentMembershipPackage = summary['currentMembershipPackage'];

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboard());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDC2626).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: user['profile_image'] != null
                                      ? StorageNetworkImage(
                                          imagePath: user['profile_image']
                                              .toString()
                                              .replaceAll('https://gym.sulthon.blue/storage/', '')
                                              .replaceAll('https://gym.sulthon.blue/', ''),
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.person, size: 32, color: Color(0xFFDC2626)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back!',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 13,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user['name'] ?? 'User',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Stats
                    Text(
                      'Ringkasan Aktivitas',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xFF18181B),
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.fitness_center,
                            label: 'Visit Gym\nBulan Ini',
                            value: '${summary['visitCountInCurrentMonth'] ?? 0}',
                            color: const Color(0xFFDC2626),
                            bgColor: const Color(0xFFFEE2E2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.trending_up,
                            label: 'Visit Gym\nMinggu Ini',
                            value: '${summary['visitCountInCurrentWeek'] ?? 0}',
                            color: const Color(0xFFEF4444),
                            bgColor: const Color(0xFFFEE2E2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.school,
                            label: 'Kelas Gym\nBulan Ini',
                            value: '${summary['gymClassCountInCurrentMonth'] ?? 0}',
                            color: const Color(0xFF52525B),
                            bgColor: const Color(0xFFF4F4F5),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            icon: Icons.timer,
                            label: 'Rata-rata\nWaktu Visit',
                            value: summary['averageVisitTimeFormatted'] ?? 'Belum Ada',
                            color: const Color(0xFF71717A),
                            bgColor: const Color(0xFFF4F4F5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Membership Status
                    Container(
                      decoration: BoxDecoration(
                        gradient: currentMembership != null
                            ? LinearGradient(
                                colors: [
                                  const Color(0xFFDC2626).withOpacity(0.1),
                                  const Color(0xFFEF4444).withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [
                                  const Color(0xFFF4F4F5),
                                  const Color(0xFFE4E4E7),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: currentMembership != null
                                  ? const Color(0xFF10B981).withOpacity(0.15)
                                  : const Color(0xFFDC2626).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: (currentMembership != null
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFDC2626)).withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              currentMembership != null
                                  ? Icons.check_circle_rounded
                                  : Icons.warning_rounded,
                              color: currentMembership != null
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFDC2626),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentMembership != null
                                      ? (currentMembershipPackage?['name'] ?? 'Membership Aktif')
                                      : 'Tidak Ada Membership Aktif',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: const Color(0xFF18181B),
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  currentMembership != null
                                      ? 'Berlaku hingga: ${_formatDate(currentMembership['end_date'])}'
                                      : 'Beli paket membership untuk mulai berolahraga',
                                  style: TextStyle(
                                    color: const Color(0xFF71717A),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (currentMembership == null)
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFDC2626).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to membership page
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Beli Paket'),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xFF18181B),
                          ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildActionCard(
                          context,
                          icon: Icons.calendar_today,
                          label: 'Book Class',
                          color: const Color(0xFFDC2626),
                          bgColor: const Color(0xFFFEE2E2),
                          onTap: () {},
                        ),
                        _buildActionCard(
                          context,
                          icon: Icons.person_outline,
                          label: 'Find Trainer',
                          color: const Color(0xFFEF4444),
                          bgColor: const Color(0xFFFEE2E2),
                          onTap: () {},
                        ),
                        _buildActionCard(
                          context,
                          icon: Icons.history,
                          label: 'View History',
                          color: const Color(0xFF52525B),
                          bgColor: const Color(0xFFF4F4F5),
                          onTap: () {},
                        ),
                        _buildActionCard(
                          context,
                          icon: Icons.qr_code,
                          label: 'Check In',
                          color: const Color(0xFF71717A),
                          bgColor: const Color(0xFFF4F4F5),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }


          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF18181B),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF71717A),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF18181B),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
