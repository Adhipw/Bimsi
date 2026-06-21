<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        $user = $request->user();
        if (! $user) {
            return response()->json(['status' => 'error', 'message' => 'Unauthenticated.'], 401);
        }

        // Check if user has the legacy string role OR any of the Spatie roles
        $hasLegacyRole = in_array($user->role, $roles);
        $hasSpatieRole = method_exists($user, 'hasAnyRole') && $user->hasAnyRole($roles);

        if (! $hasLegacyRole && ! $hasSpatieRole) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak memiliki akses ke halaman ini.'
            ], 403);
        }

        return $next($request);
    }
}
