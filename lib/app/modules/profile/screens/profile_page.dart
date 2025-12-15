import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/repositories/auth_repository.dart';
import 'package:gym_app/app/modules/auth/bloc/auth_bloc.dart';
import 'package:gym_app/app/widgets/storage_network_image.dart';
import 'package:gym_app/app/modules/profile/bloc/profile_bloc.dart';
import 'package:gym_app/app/modules/profile/screens/update_profile_page.dart';
import 'package:gym_app/app/modules/profile/screens/update_password_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        automaticallyImplyLeading: false,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black.withOpacity(0.05),
            height: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFDC2626)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.read<AuthBloc>().add(
                          AuthLogoutRequested(),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, Object>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDC2626).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: const Color(0xFFF4F4F5),
                        child: ClipOval(
                          child: user.profileImage != null
                              ? StorageNetworkImage(
                                  imagePath: user.profileImagePath,
                                  width: 112,
                                  height: 112,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, size: 56, color: Color(0xFF71717A)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF18181B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.email,
                    style: const TextStyle(color: Color(0xFF71717A), fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDC2626).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      user.role.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Container(
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
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.phone, color: Color(0xFFDC2626), size: 20),
                          ),
                          title: const Text('Phone', style: TextStyle(fontSize: 14, color: Color(0xFF71717A))),
                          subtitle: Text(
                            user.phone ?? 'Not set',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF18181B)),
                          ),
                        ),
                        Divider(height: 1, color: Colors.black.withOpacity(0.05)),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.card_membership, color: Color(0xFFDC2626), size: 20),
                          ),
                          title: const Text('Membership Status', style: TextStyle(fontSize: 14, color: Color(0xFF71717A))),
                          subtitle: Text(
                            user.isMembershipActive ? 'Active' : 'Inactive',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF18181B)),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: user.isMembershipActive ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              user.isMembershipActive ? Icons.check_circle : Icons.cancel,
                              color: user.isMembershipActive ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              size: 20,
                            ),
                          ),
                        ),
                        if (user.membershipEndDate != null) ...[
                          Divider(height: 1, color: Colors.black.withOpacity(0.05)),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.calendar_today, color: Color(0xFF71717A), size: 20),
                            ),
                            title: const Text('Membership Expires', style: TextStyle(fontSize: 14, color: Color(0xFF71717A))),
                            subtitle: Text(
                              '${user.membershipEndDate!.day}/${user.membershipEndDate!.month}/${user.membershipEndDate!.year}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF18181B)),
                            ),
                          ),
                        ],
                        Divider(height: 1, color: Colors.black.withOpacity(0.05)),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.verified, color: Color(0xFF71717A), size: 20),
                          ),
                          title: const Text('Email Verified', style: TextStyle(fontSize: 14, color: Color(0xFF71717A))),
                          trailing: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: user.isEmailVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              user.isEmailVerified ? Icons.check_circle : Icons.cancel,
                              color: user.isEmailVerified ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
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
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.edit, color: Color(0xFFDC2626), size: 20),
                          ),
                          title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF18181B))),
                          trailing: const Icon(Icons.chevron_right, color: Color(0xFF71717A)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProfileBloc(
                                    authRepository: AuthRepository(),
                                  ),
                                  child: const UpdateProfilePage(),
                                ),
                              ),
                            );
                          },
                        ),
                        Divider(height: 1, color: Colors.black.withOpacity(0.05)),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.lock, color: Color(0xFF71717A), size: 20),
                          ),
                          title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF18181B))),
                          trailing: const Icon(Icons.chevron_right, color: Color(0xFF71717A)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => ProfileBloc(
                                    authRepository: AuthRepository(),
                                  ),
                                  child: const UpdatePasswordPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        // const Divider(height: 1),
                        // ListTile(
                        //   leading: const Icon(Icons.settings),
                        //   title: const Text('Settings'),
                        //   trailing: const Icon(Icons.chevron_right),
                        //   onTap: () {
                        //     // TODO: Navigate to settings
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
