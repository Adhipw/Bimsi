<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Models\PesanChat;

class PesanChatController extends Controller
{
    public function getMessages($pengajuan_judul_id)
    {
        $messages = PesanChat::where('pengajuan_judul_id', $pengajuan_judul_id)
            ->orderBy('created_at', 'asc')
            ->get();
            
        return response()->json($messages);
    }

    public function sendMessage(Request $request)
    {
        $validated = $request->validate([
            'pengajuan_judul_id' => 'required|exists:pengajuan_juduls,id',
            'pengirim_id' => 'required|exists:users,id',
            'penerima_id' => 'required|exists:users,id',
            'pesan' => 'required|string',
        ]);

        $message = PesanChat::create($validated);
        
        // TODO: Broadcast event via Pusher here
        // event(new ChatMessageSent($message));

        return response()->json($message, 201);
    }

    public function markAsRead($id)
    {
        $message = PesanChat::findOrFail($id);
        $message->update(['is_read' => true]);

        return response()->json(['message' => 'Read marked']);
    }
}
