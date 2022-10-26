Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF72C433FE
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Oct 2022 16:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiJZQvW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Oct 2022 12:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiJZQvV (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 26 Oct 2022 12:51:21 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6223BA02E8
        for <linux-sgx@vger.kernel.org>; Wed, 26 Oct 2022 09:51:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c24so14687115pls.9
        for <linux-sgx@vger.kernel.org>; Wed, 26 Oct 2022 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F3Gn5MMNvRImyihxa0X0XlGwXxVXMB5wSNFtQRNnBcw=;
        b=Z9tRd5vcXhtb8lNuABr29N8KVLf9JJnYJn4SXaBd+XlaWCJSgFYteExGmyPywK8wOo
         4XCxhBd/j/3joOzxOSHNXj5S1eNxLp84qCobzbVziwL+mMdaUXbagEEQ017nAGhFQTHn
         2YrZscmy/nGwHVbaZCgxXPsNt85n/id9KlTXTpppha1G+FKefwd14p00z35RnDxGe4dn
         njkqXWnDWKdHwio7Jjpi43kHe1/YysaIfe3U9SPa42zaNRuBa9zsgfk2fP5oM0SKFt2E
         Ea+qUFfM/dkwporIXW6QljprpMoPD1F4LobeGMF3dJZInmEY9IdKcEwUeDqBwHZkhx0Z
         vTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3Gn5MMNvRImyihxa0X0XlGwXxVXMB5wSNFtQRNnBcw=;
        b=nnaP7t15a4xAkga14B2xLckeD5EWXUnjLPK1M0EhgVYSXEzrurwyWlbHu88c0cqXSr
         kzEbS92Ig6P9/Tt+/oxhJkEtnNkuMpiA6cy4XxEcr57LBOVrHZ3cXHfBDwiXIN0I9KJ3
         K1htXPnjLRNiDjWAGvTpSt/UQrmlDeJGwfBv88nl66XEbAnpvsHqiJtXTkEJclXdiMjX
         9GbbrQKTzNr241ggj35YAkGf660PWQvwe9FPsBpVBa7GPKsdu7W/OkOCYzqmLlsVVO2e
         SfwxLbSbYLskERiw8JnGUQTUsZogAP1RLdjW28zHkBoA+kujdIIcVdeLvYhqFPJ5aljS
         Djzw==
X-Gm-Message-State: ACrzQf0jHNSp8KuHjSisrVHu0VtK/sqkEGDfk98b6/wTEsK0lNIBqh8+
        hcRuE/w6YrpDOqaoqFkr/tOR0g==
X-Google-Smtp-Source: AMsMyM5wCMQejQ4Ij+jmACLJgk8FedJzMuNzOgDgwt5Q3b0u1sXhp0JARiWqVkTZjqJNp5R3YaHn7A==
X-Received: by 2002:a17:90b:4f82:b0:213:4d2f:9853 with SMTP id qe2-20020a17090b4f8200b002134d2f9853mr5241502pjb.200.1666803075789;
        Wed, 26 Oct 2022 09:51:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t7-20020a170902e84700b00186a6b6350esm3133696plg.268.2022.10.26.09.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 09:51:15 -0700 (PDT)
Date:   Wed, 26 Oct 2022 16:51:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+dbef12497aa912c8e7ba@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [syzbot] WARNING in vcpu_enter_guest (2)
Message-ID: <Y1llf2N3sx1bqWYa@google.com>
References: <000000000000c2ba5205ebe680bc@google.com>
 <CACT4Y+be9iD66uAfnjDW+skos1b1-0vvoc1GxS9_OS0vfCmCRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+be9iD66uAfnjDW+skos1b1-0vvoc1GxS9_OS0vfCmCRQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Oct 26, 2022, Dmitry Vyukov wrote:
> On Tue, 25 Oct 2022 at 19:08, syzbot
> <syzbot+dbef12497aa912c8e7ba@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    4dc12f37a8e9 Merge tag 'platform-drivers-x86-v6.1-2' of gi..
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=113363d2880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
> > dashboard link: https://syzkaller.appspot.com/bug?extid=dbef12497aa912c8e7ba
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132e84fc880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a872f2880000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/7858e54948b9/disk-4dc12f37.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/f37bd48d06dc/vmlinux-4dc12f37.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/98114f50afb3/bzImage-4dc12f37.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+dbef12497aa912c8e7ba@syzkaller.appspotmail.com
> 
> This will be fixed by the following commit, right?

Yep, thanks!

> #syz fix:
> KVM: x86: Exempt pending triple fault from event injection sanity check
> 
> https://lore.kernel.org/all/20220930230008.1636044-1-seanjc@google.com/
