import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_footer.dart';
import '../../core/widgets/app_header.dart';
import '../../features/booking/booking_page.dart';
import '../../features/contact/contact_page.dart';
import '../../features/events/events_page.dart';
import '../../features/gallery/gallery_page.dart';
import '../../features/home/home_page.dart';
import '../../features/menu/menu_page.dart';
import '../../features/terms/terms_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppHeader(currentRoute: state.uri.path),
          endDrawer: AppMobileDrawer(currentRoute: state.uri.path),
          body: SingleChildScrollView(
            child: Column(
              children: [
                child,
                const AppFooter(),
              ],
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/menu',
          builder: (context, state) => const MenuPage(),
        ),
        GoRoute(
          path: '/gallery',
          builder: (context, state) => const GalleryPage(),
        ),
        GoRoute(
          path: '/booking',
          builder: (context, state) => const BookingPage(),
        ),
        GoRoute(
          path: '/events',
          builder: (context, state) => const EventsPage(),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactPage(),
        ),
        GoRoute(
          path: '/terms',
          builder: (context, state) => const TermsPage(),
        ),
      ],
    ),
  ],
);
