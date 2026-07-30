// AI Coach screen - chat interface with holographic avatar, smart replies, glowing input
// Redesigned as Coach tab in the app
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _quickReplies = ['Start Walk', 'Stretch routine', 'Log water'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ChatProvider>().loadHistory());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final msg = text ?? _ctrl.text.trim();
    if (msg.isEmpty) return;
    context.read<ChatProvider>().send(msg);
    if (text == null) _ctrl.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Top App Bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: AppColors.onSurface, size: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'DAILY PULSE',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.settings_outlined, color: AppColors.primary, size: 22),
              ],
            ),
          ),

          // AI Avatar Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Holographic Avatar
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer scanning rings
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondaryContainer.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryContainer.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.smart_toy_rounded,
                          size: 50,
                          color: AppColors.secondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'COACH AI',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryContainer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SYNCED & ANALYZING',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppColors.secondaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: chat.messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 48,
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ask your coach anything!',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: chat.messages.length + 2, // +2 for initial AI messages
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return _AiMessage(
                          text: "Rise and grind! You're currently at 9,500 steps. You're only 500 steps away from your daily goal!",
                          time: 'Just now',
                          color: AppColors.secondaryContainer,
                        );
                      }
                      if (i == 1) {
                        return _AiMessage(
                          text: "\"Your biomechanics data shows a slight fatigue in your left quadriceps. I recommend a quick walk and light stretching to hit that goal.\"",
                          time: '2 min ago',
                          color: AppColors.primaryContainer,
                          suggestion: 'EXO_SUGGESTION: ACTIVE RECOVERY',
                        );
                      }
                      final msgIndex = i - 2;
                      if (msgIndex < chat.messages.length) {
                        final msg = chat.messages[msgIndex];
                        return _UserMessage(text: msg.response, time: msg.timestamp);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),

          // Loading indicator
          if (chat.loading)
            const LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryContainer),
            ),

          // Quick Replies & Input
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                // Quick replies
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickReplies.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () => _send(_quickReplies[i]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: i == 0
                                ? AppColors.secondaryContainer.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: i == 0
                                  ? AppColors.secondaryContainer.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _quickReplies[i],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: i == 0
                                    ? AppColors.secondaryContainer
                                    : AppColors.onSurface.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // Input field with glow
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryContainer.withValues(alpha: 0.1),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.surfaceContainerHigh,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            style: GoogleFonts.inter(
                              color: AppColors.onSurface,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ask your coach anything...',
                              hintStyle: GoogleFonts.inter(
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                                fontSize: 15,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: chat.loading ? null : () => _send(),
                            icon: const Icon(Icons.arrow_forward_rounded),
                            color: AppColors.onPrimaryContainer,
                            iconSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiMessage extends StatelessWidget {
  final String text;
  final String time;
  final Color color;
  final String? suggestion;

  const _AiMessage({
    required this.text,
    required this.time,
    required this.color,
    this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  left: BorderSide(color: color, width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.onSurface,
                      height: 1.5,
                    ),
                  ),
                  if (suggestion != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.bolt_rounded, color: AppColors.primaryContainer, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          suggestion!,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryContainer,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  final String text;
  final DateTime? time;

  const _UserMessage({required this.text, this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
