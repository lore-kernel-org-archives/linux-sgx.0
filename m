Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C37C432BE
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Aug 2021 15:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0442760F56
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Aug 2021 15:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhH3PnA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Aug 2021 11:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237604AbhH3PnA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 30 Aug 2021 11:43:00 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8618C06175F
        for <linux-sgx@vger.kernel.org>; Mon, 30 Aug 2021 08:42:06 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mj9-20020a17090b368900b001965618d019so4036772pjb.4
        for <linux-sgx@vger.kernel.org>; Mon, 30 Aug 2021 08:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lk3dNfnbxwb9IGxCTTy4Crpi7GjccN8ibRlNAb6VBdM=;
        b=wFlfNk17Q3KmvZ1biMt+GfBkmu0p3Ce6GXAJtP0tAp7ZXzvTMD67v9o9guVgixH7Tb
         kZPUqpTAbUTjWc1fMxKc+dmvF21CAOmR2Gxtv8LHZPatCtVBTdpwCMA2ZCXHnqs/xqUX
         tTEJXVaBm0mUlNmRaba58fKoHpOAJ6fWbY5Kib6MILA0w80JZOaHRg6h53c6XszD/OtU
         VGmnDjOGRwY/ysqHb4tczJ9LBLtOlrjfk32x/xlEbda0omkc8dTlAjRWe5qDwNdJRQFQ
         AQD5c95stzGawJqbjA5P1UAeiCwpISd+3W0X2GAlXEjBG3P2PJgHthk0L4MKsZu85u5K
         VTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lk3dNfnbxwb9IGxCTTy4Crpi7GjccN8ibRlNAb6VBdM=;
        b=Ep9A2d4zZ+TOUgxA7gnQu0juVqRaDsvToBhtJ9cYVeTjSZ6P3PnTepoF6cT+oUgHE/
         MzeWI+CsHZ3NkMC3+tXA1KAS+fvmOB964U0sfBLO3dPWEffNTAvyMw2fEKkBGBXj6wJ1
         gMtpTpmNkFVmYVYWkyQM6J3s9bi4I1NpGjwZRRVUIyG5tGU3r5VIyGnrgNQ4EqDQ4e15
         pHswUFd0lFRKftugyeS9Hd+y4f5XvlsmQgX8oDn7B7sKnzC/pmqGy8n4LFsNFbE+EykS
         ZiQHuaJ9AXvDaVnab+CoxqfcJIZyDZ4Q8QetGul88PgdeFFeqhuezzSjtaV/qvuzQfM8
         VQMw==
X-Gm-Message-State: AOAM5315x2MJ9pacZBUhTv/rhVMjq0OC9nwTePUSu+UgVgEmrQZ5e25h
        xiXkVwprvbGOABFZX6OvBtPLEw==
X-Google-Smtp-Source: ABdhPJx+lopma4AgkjICQ8jnGEHv26dZVDa3YeR++YNuraXhAkglsID4yMm6PZ2D9hA1YCzx1zsGHQ==
X-Received: by 2002:a17:90a:ea08:: with SMTP id w8mr37457611pjy.218.1630338126036;
        Mon, 30 Aug 2021 08:42:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d17sm14836938pfn.110.2021.08.30.08.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 08:42:05 -0700 (PDT)
Date:   Mon, 30 Aug 2021 15:42:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] WARNING in exception_type
Message-ID: <YSz8SVKML5Ilxedn@google.com>
References: <000000000000fa5aea05cac3895f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fa5aea05cac3895f@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 30, 2021, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3f5ad13cb012 Merge tag 'scsi-fixes' of git://git.kernel.or..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=156f9a4d300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=94074b5caf8665c7
> dashboard link: https://syzkaller.appspot.com/bug?extid=200c08e88ae818f849ce
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13848dfe300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136d69e1300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+200c08e88ae818f849ce@syzkaller.appspotmail.com
> 
> L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 8469 at arch/x86/kvm/x86.c:525 exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
> Modules linked in:
> CPU: 1 PID: 8469 Comm: syz-executor531 Not tainted 5.14.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:exception_type+0x98/0xb0 arch/x86/kvm/x86.c:525
> Code: 31 ff 45 31 ed 44 89 e6 e8 25 75 69 00 45 85 e4 41 0f 95 c5 45 01 ed e8 d6 6d 69 00 44 89 e8 5b 41 5c 41 5d c3 e8 c8 6d 69 00 <0f> 0b e8 c1 6d 69 00 41 bd 03 00 00 00 5b 44 89 e8 41 5c 41 5d c3
> RSP: 0018:ffffc90000f1f8f0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 00000000000000a2 RCX: 0000000000000000
> RDX: ffff888018461c40 RSI: ffffffff810c3b28 RDI: 0000000000000003
> RBP: ffff888020868000 R08: 000000000000001f R09: 00000000000000a2
> R10: ffffffff810c3aaa R11: 0000000000000006 R12: 00000000000000a2
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000040
> FS:  000000000179c300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fffd362aad8 CR3: 00000000182ef000 CR4: 00000000001526e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  x86_emulate_instruction+0xef6/0x1460 arch/x86/kvm/x86.c:7853

LOL, syzbot configures the VM with MAXPHYADDR=1 and hilarity ensues.  The non-nested
translate_gfn() fails to prepare the #PF, and also doesn't check allow_smaller_maxphyaddr.
I should get a series out today to clean up the mess.

>  kvm_mmu_page_fault+0x2f0/0x1810 arch/x86/kvm/mmu/mmu.c:5199
>  handle_ept_misconfig+0xdf/0x3e0 arch/x86/kvm/vmx/vmx.c:5336
>  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6021 [inline]
>  vmx_handle_exit+0x336/0x1800 arch/x86/kvm/vmx/vmx.c:6038
>  vcpu_enter_guest+0x2a1c/0x4430 arch/x86/kvm/x86.c:9712
>  vcpu_run arch/x86/kvm/x86.c:9779 [inline]
>  kvm_arch_vcpu_ioctl_run+0x47d/0x1b20 arch/x86/kvm/x86.c:10010
>  kvm_vcpu_ioctl+0x49e/0xe50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3652
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:1069 [inline]
>  __se_sys_ioctl fs/ioctl.c:1055 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x441159
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd362c598 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 0000000000441159
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 0000000000404c50 R08: 0000000000400488 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000404ce0
> R13: 0000000000000000 R14: 00000000004ae018 R15: 0000000000400488
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
