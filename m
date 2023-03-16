Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9926C7618A
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Mar 2023 19:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjCPTgW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjCPTgV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 16 Mar 2023 15:36:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8E976159
        for <linux-sgx@vger.kernel.org>; Thu, 16 Mar 2023 12:36:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e129-20020a251e87000000b00b56598237f5so2873021ybe.16
        for <linux-sgx@vger.kernel.org>; Thu, 16 Mar 2023 12:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678995376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yLXQDEpA7yMBHY3pvsFbW1lWjQMlNDrFYkskb+8dWQw=;
        b=PrB4vwvW5iv11UJZpooT7rvslKfDWjKGT7LJSCkScrFN77cNUoEu4Is6TyO/uq1pM8
         rUVfMYnae2iHqUz0IOi0o+jheqTLS1yi3io9ANUg3z3mal53hfvKcgD993sjQSDsSTfr
         fnV9U2X+NoLTmyLVPe9vlekbkFI9tWk1H2wLrizaagkhUfgFCW43xmu+fHBEgSbLNh3M
         gtsPAC/1ahNIRRZ5MIiF3R7f71M/IWqrO4V61dxBBQ80ccXd1IHlka9of+rNFJEFToqZ
         k3tvrTBHPoHCJzJHDOqbzPyG0eoqQDUJP71H7wAWSLHS+YxFzmPcMHU5RrHfrGVAkw5O
         DwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678995376;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yLXQDEpA7yMBHY3pvsFbW1lWjQMlNDrFYkskb+8dWQw=;
        b=aSa4nfqnkrjfCUhJYRHZ3WKbwGAjiMTeaTmauq0X9ZHXlyxvGKID3FXccRwLccDO98
         DP8Iot+5Ig9jtp9TdZrFo/JvuFtrJZY17DyQ3cLLoi9SRmdnyPjy6ZphEtxEn5PNNZkc
         3Y7C8eJUyvXBZd+hWaIhBc0HLooRiOwNN/68iAd9gTw9/lNE/vk6rNzyUoKK09lMXowp
         N0K2Sx+7xjUIkLnjqszGHaxnTSqi75ma0souAD6qwvBU2f1yD8wT7sJKNuaTFn0+senp
         E66WT64VAhcgAag5nWxaKfQuHaYHE85VFP59dxw1RKH3FU+Fs8YDfQ6RLYniMVBzCNyE
         Mt+Q==
X-Gm-Message-State: AO0yUKWz3Sha0TfZsWAI343XBWwNe+qMvO/ygdWdh9UkmnvTXcdlqZOX
        DO8vBCTN3mYA6agyVr2wQeN4Ac8TT3s=
X-Google-Smtp-Source: AK7set/jMiOWZ6MfnT/kZfZ9gW4uYomOjI9N6aA3TvUYokg/XSTvTQoJd1TbVa2nB7q5J71HLZCidR+AbOg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4005:0:b0:544:6455:e023 with SMTP id
 l5-20020a814005000000b005446455e023mr2927636ywn.10.1678995376823; Thu, 16 Mar
 2023 12:36:16 -0700 (PDT)
Date:   Thu, 16 Mar 2023 19:36:15 +0000
In-Reply-To: <0000000000009af47405f7093fc6@google.com>
Mime-Version: 1.0
References: <0000000000009af47405f7093fc6@google.com>
Message-ID: <ZBNvrx3Q9Wa3WqXL@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_arch_vcpu_ioctl_run (4)
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+8accb43ddc6bd1f5713a@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 16, 2023, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ee3f96b16468 Merge tag 'nfsd-6.3-1' of git://git.kernel.or..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=11622f64c80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
> dashboard link: https://syzkaller.appspot.com/bug?extid=8accb43ddc6bd1f5713a
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bd61acc80000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17402eb0c80000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a7ac3e540d6d/disk-ee3f96b1.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/604b5042d73d/vmlinux-ee3f96b1.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5a6d400b42b5/bzImage-ee3f96b1.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8accb43ddc6bd1f5713a@syzkaller.appspotmail.com
> 
> kvm_intel: KVM_SET_TSS_ADDR needs to be called before running vCPU
> kvm_intel: set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5082 at arch/x86/kvm/x86.c:11060 kvm_arch_vcpu_ioctl_run+0x2464/0x2af0 arch/x86/kvm/x86.c:11060
> Modules linked in:
> CPU: 0 PID: 5082 Comm: syz-executor178 Not tainted 6.2.0-syzkaller-13115-gee3f96b16468 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
> RIP: 0010:kvm_arch_vcpu_ioctl_run+0x2464/0x2af0 arch/x86/kvm/x86.c:11060

Same thing reported by another syzkaller instance, I'll post fixes in the not too
distant future.

https://lore.kernel.org/all/ZBNrWZQhMX8AHzWM@google.com
