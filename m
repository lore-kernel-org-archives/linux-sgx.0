Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D1CCC7EE2E
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Jun 2023 23:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjFLXO6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Jun 2023 19:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbjFLXO5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 12 Jun 2023 19:14:57 -0400
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EC4E6B
        for <linux-sgx@vger.kernel.org>; Mon, 12 Jun 2023 16:14:55 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-777ab76f328so511888939f.1
        for <linux-sgx@vger.kernel.org>; Mon, 12 Jun 2023 16:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686611695; x=1689203695;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jsD8wrhGA47bvs9VWblevEEM+2ODQ4KqY40h7I8sNYc=;
        b=gc+Hwf1OWAFfvosgTGcYQKynyWjNZF23we1t4dNg9pSIAdCvfwHLuG6lUKL936Wvsw
         ltvfCjQkiVZF1vILtWEnoTGNxcMatb1juXQFNQEklUPciOxE8My9ImppjmA/FwthR7Dw
         M3DYmAX1FV3S+Vp7nsmcl+3Rk0BSHTCaWQ7xsJqEzoOsblUPp38yR6lqriohXig4oy/t
         rQIZjQ+XN/46P4qZfvssO08VsPEl4AC7yaGx3oxctLU+gKs1+IE14zv5d5/X9FrP/pyM
         DEE1Pk6xeRUbHkJkXuILac1VDXTdGPouz9ceRL0BWXJGHFry9ZTYlP2H7A7waLlTClN2
         vHHQ==
X-Gm-Message-State: AC+VfDyNGbVHYiC3UB0IVExkIrSuOdHw+kOpCObjbR6Ce4jqSKfOgMPO
        NZwyZivarngEfnZoCcRWCFE2GIEbrFis5nOG1Ldh0ka+RPDf
X-Google-Smtp-Source: ACHHUZ6x/KiSmpGQ0QxEP4u1ce5ANRm73sWpyb/F4KXTYnU0+4y00qG+JLuXabipCF23O2qXXaHQtgVMJBXou7WyWovzm/BGkFt5
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c81:b0:777:b0ee:a512 with SMTP id
 i1-20020a0566022c8100b00777b0eea512mr8742821iow.2.1686611694915; Mon, 12 Jun
 2023 16:14:54 -0700 (PDT)
Date:   Mon, 12 Jun 2023 16:14:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f316b705fdf6e2b4@google.com>
Subject: [syzbot] [kvm?] WARNING in kvm_arch_vcpu_ioctl_run (5)
From:   syzbot <syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    64569520920a Merge tag 'block-6.4-2023-06-09' of git://git..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12386cd9280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c980bfe8b399968
dashboard link: https://syzkaller.appspot.com/bug?extid=5feef0b9ee9c8e9e5689
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13adcb43280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13af3853280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4421ae3b4ee0/disk-64569520.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9312cbb35f54/vmlinux-64569520.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3476854febf3/bzImage-64569520.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com

kvm_intel: L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
kvm: vcpu 1: requested 128 ns lapic timer period limited to 200000 ns
kvm: vcpu 1: requested lapic timer restore with starting count register 0x390=1812281087 (231971979136 ns) > initial count (200000 ns). Using initial count to start timer.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5004 at arch/x86/kvm/x86.c:11099 kvm_arch_vcpu_ioctl_run+0x2379/0x2820 arch/x86/kvm/x86.c:11099
Modules linked in:
CPU: 1 PID: 5004 Comm: syz-executor120 Not tainted 6.4.0-rc5-syzkaller-00245-g64569520920a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
RIP: 0010:kvm_arch_vcpu_ioctl_run+0x2379/0x2820 arch/x86/kvm/x86.c:11099
Code: fc ff ff e8 19 64 71 00 44 89 e6 48 c7 c7 40 8a 42 8a c6 05 cd e9 51 0d 01 e8 53 1f 39 00 0f 0b e9 2a fc ff ff e8 f7 63 71 00 <0f> 0b e9 26 fb ff ff e8 eb 63 71 00 0f b6 1d aa e9 51 0d 31 ff 89
RSP: 0018:ffffc90003a8fcb8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888015b9d940 RSI: ffffffff8112e2e9 RDI: 0000000000000001
RBP: ffff88807dae8000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffffc900015a7918
R13: ffffc900015a7908 R14: 0000000000000000 R15: ffff88807dae82ec
FS:  00005555572d6300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020fe9008 CR3: 000000007be99000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_vcpu_ioctl+0x574/0xea0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4106
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0464e7ec99
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffded877408 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0464e7ec99
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f0464e426f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0464e42780
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
