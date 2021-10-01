Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6607CC433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 15:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA6761A6F
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 15:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354917AbhJAPPE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Oct 2021 11:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354912AbhJAPPD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Oct 2021 11:15:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755EFC06177C
        for <linux-sgx@vger.kernel.org>; Fri,  1 Oct 2021 08:13:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x4so6504083pln.5
        for <linux-sgx@vger.kernel.org>; Fri, 01 Oct 2021 08:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=epqGvL2xwASJxQVBW1Iu4NCeLliUpYCfDqhNCQQ6Qu4=;
        b=RmL9twmGl1cux62in5hgYRWjsjWQRTNuCw+2HHC11ZPLnWbcNtrkeKO6qsTnVf+AQI
         VOHQZCPXkfGqGtl5egoUHs0ILgIe2nryR/iHwonKaQCQvp4wXQ7b5dGcNp6j8Hc7F2p5
         lF2wIk+KpQaBVIFo4HvybjQ5oAjVigRE6s2a7on8nAjU5NSqQ7ZxFvqeBgiw6FqjLH7Q
         Tm2VM9gpKyNNiHlUPe7GanCql6KYPqZp3w3N+wwbu/Im+t270KnjjhVY8SUrLdKcoaaK
         dk7IGEx9L9po679KQv6O2726NPU3pcl0iQmZGhHy9TcM9+xBtxeRPDelGVQqPTkJHoQT
         D2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=epqGvL2xwASJxQVBW1Iu4NCeLliUpYCfDqhNCQQ6Qu4=;
        b=XUqgEH9H7m9cPcP1shlxokcoFRuBiI6ajT4F2mM0wloDr6rkcU8kaQ3SI2cIlw6FMM
         x1Pawb3eZVN8EO+u9WGVJ+FQTRhqAjSdB/Huhw0oWt1Ukn0wBnbpLjpChZ62gKFGPOvy
         CPwJ+eZ2nw6CIg7StOFL2FbM4JuOnn3E8EtIoGH5SecTGcyTZ1KwvrZN/JiReBvpYOUU
         zmRLBwkEi4cGdNlUnYNXHJKUPicQMZ37a0E1xd5Ax7RiAB/Y1f4y//MeplrIQ4F+miHp
         /hdzsT8r99T4qklgxKJ+evPuciQy4otQmLDxBDjIN64ov0sIC6nwzsUw7kVt53FPNpLX
         l19w==
X-Gm-Message-State: AOAM530tefiCYxsdpxvb2ont5usqxV0+eshwGX/EmT8XAkLEA0US09V4
        t+ZQUMNNWALqz11KBckptLTN8A==
X-Google-Smtp-Source: ABdhPJwayzCtSnysz+R4jnKXc7dOdpaqRQaloWu6UZiyZVUaDl75+fhEkUoWnJ6S2FZUlI8UcciF6Q==
X-Received: by 2002:a17:902:aa91:b0:13e:292f:266a with SMTP id d17-20020a170902aa9100b0013e292f266amr10000865plr.10.1633101198760;
        Fri, 01 Oct 2021 08:13:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v2sm5991593pje.15.2021.10.01.08.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 08:13:18 -0700 (PDT)
Date:   Fri, 1 Oct 2021 15:13:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     syzbot <syzbot+d6d011bc17bb751d4aa2@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, glider@google.com,
        hpa@zytor.com, jarkko@kernel.org, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: [syzbot] KMSAN: uninit-value in kvm_cpuid
Message-ID: <YVclio5ny4ziKQer@google.com>
References: <00000000000048342f05cd44efc0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000048342f05cd44efc0@google.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 30, 2021, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    cd2c05533838 DO-NOT-SUBMIT: kmsan: suppress a report in ke..
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=11373b17300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=978f1b2d7a5aad3e
> dashboard link: https://syzkaller.appspot.com/bug?extid=d6d011bc17bb751d4aa2
> compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b6c4cb300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fdb00f300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d6d011bc17bb751d4aa2@syzkaller.appspotmail.com

#syz fix: KVM: x86: Swap order of CPUID entry "index" vs. "significant flag" checks
