<?php

use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

Broadcast::channel('kaprodi.notifications', function ($user) {
    return $user->role === 'kaprodi';
});

Broadcast::channel('mahasiswa.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id && $user->role === 'mahasiswa';
});
