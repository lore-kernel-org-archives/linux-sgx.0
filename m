Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3417BC83F15
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Aug 2023 15:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjH1PMO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Aug 2023 11:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbjH1PMJ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 28 Aug 2023 11:12:09 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9204412A
        for <linux-sgx@vger.kernel.org>; Mon, 28 Aug 2023 08:11:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5925fb6087bso48896887b3.2
        for <linux-sgx@vger.kernel.org>; Mon, 28 Aug 2023 08:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693235505; x=1693840305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AgTfuJ+2SR7wHNk0wScsVJOKb9hSrrlOBi0oejIscH4=;
        b=HfCi+0j4q9UL5mmi0D0c0vIBnMfZ8sVJJnsmxNZYbaR0Ybr1N6e0ZQCYEwymlICUtr
         bcBrTLBd8dC1xc2OkUA7ey/hHRUI7Z7GMC/EYt/P1CvuYpQTJSKmbsudOLUhxPI3175+
         pPXXItH3l1vV5sjno3lvfYnsux22sCmmr9PkW5oI2uYfLWkgtDFIz+VC+S9W2JvrIrby
         YMpZwKrKd1RsqLlOtdx1jblDVD22DsqrckU+l6Tcfdpc84H/yMwgLc0eHPQl5mU80bH0
         GyyGXVxPaav503NLQyiroWVJuXGEBBEO1cGC+soz0rGCa3BEJXNKvQKXcHPlSOSdEM+1
         PcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693235505; x=1693840305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgTfuJ+2SR7wHNk0wScsVJOKb9hSrrlOBi0oejIscH4=;
        b=JNwH/AuQzk0WV+dUmpS9AgS9LYtQpAt7l82QqBmDwdQwsd35FYJthI42a4cJJlkDYo
         RcplQUWAq936aRNYD4LFViGvcTWR/EaCodGlomDj2UmuNkjcJwD8u4ZWhyXaLTY8iohe
         rPe1HNpJA1pgrDh2A2+gKJL6ZyZii26CmZSBoSLV4D3Yb9z8juFs15x4PPO2hR2Kj5c1
         3eIK0a5Bfu97jBsLP0YR61JdC4jExlki6aN9bgnkLl9saclwdmVkfQDK3jZsvyL6HlEP
         ukkwBbvQ2oAl9HMpS0UcVsCLMBqvhCfa9Y7ltzxJgQPXMGn8Qaepms1lKUFG8Y/GtWfX
         YF5w==
X-Gm-Message-State: AOJu0YxGR5GfhfNfpU/xnEjpDIDL38a8CH5l5pxR22q5LzYgW7SrGfeM
        OSgXyIJUGnpdUrLvFKqZx2262ROGu5Y=
X-Google-Smtp-Source: AGHT+IFSfKyGlY1fJVyJDDAAQ2F/jDYjdtTldF9OG/AD25pzxWtoQEJJC/FkS5GCYAB4JJjrKDQknRmDUnM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d650:0:b0:d51:577e:425d with SMTP id
 n77-20020a25d650000000b00d51577e425dmr809965ybg.12.1693235504854; Mon, 28 Aug
 2023 08:11:44 -0700 (PDT)
Date:   Mon, 28 Aug 2023 08:11:43 -0700
In-Reply-To: <edeca3d3-bf4c-4c5d-8879-dca5173b6659@collabora.com>
Mime-Version: 1.0
References: <00000000000099cf1805faee14d7@google.com> <edeca3d3-bf4c-4c5d-8879-dca5173b6659@collabora.com>
Message-ID: <ZOy5L4WCiy1hsiu0@google.com>
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
From:   Sean Christopherson <seanjc@google.com>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>,
        syzkaller-lts-bugs@googlegroups.com,
        syzbot <syzbot+b000b7d21f93fc69de32@syzkaller.appspotmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 28, 2023, Muhammad Usama Anjum wrote:
> On 5/5/23 1:28 PM, syzbot wrote:
> > syzbot has found a reproducer for the following issue on:
> > 
> > HEAD commit: 8a7f2a5c5aa1 Linux 5.15.110
> This same warning has also been found on  6.1.21.
> 
> > git tree: linux-5.15.y
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15f12318280000
> > kernel config: https://syzkaller.appspot.com/x/.config?x=ba8d5c9d6c5289f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e
> > compiler: Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro: https://syzkaller.appspot.com/x/repro.syz?x=10e13c84280000
> > C reproducer: https://syzkaller.appspot.com/x/repro.c?x=149d9470280000
> I've tried all the C and syz reproducers. I've also tried syz-crash which
> launched multiple instances of VMs and ran syz reproducer. But the issue
> didn't get reproduced.
> 
> I don't have kvm skills. Can someone have a look at the the warning
> (probably by static analysis)?
> 
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/fc04f54c047f/disk-8a7f2a5c.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/6b4ba4cb1191/vmlinux-8a7f2a5c.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/d927dc3f9670/bzImage-8a7f2a5c.xz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 3502 at arch/x86/kvm/x86.c:10310 kvm_arch_vcpu_ioctl_run+0x1d63/0x1f80

"Fixed" by https://lore.kernel.org/all/20230808232057.2498287-1-seanjc@google.com,
in quotes because sadly the fix was to simply delete the sanity check :-(
