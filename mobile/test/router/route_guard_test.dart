import 'package:family_veda/providers/auth_provider.dart';
import 'package:family_veda/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unauthenticated user is redirected from protected route', () {
    expect(
      routeRedirect(
        auth: const AuthState.unauthenticated(),
        activeMemberId: null,
        location: '/records',
      ),
      '/login',
    );
  });

  test('member-scoped route requires an active member', () {
    expect(
      routeRedirect(
        auth: const AuthState.authenticated(),
        activeMemberId: null,
        location: '/guidance/case-1',
      ),
      '/members',
    );
  });

  test('authenticated user with active member may access records', () {
    expect(
      routeRedirect(
        auth: const AuthState.authenticated(),
        activeMemberId: 'member-1',
        location: '/records',
      ),
      isNull,
    );
  });
}
