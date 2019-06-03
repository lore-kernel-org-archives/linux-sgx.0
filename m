Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B81DC04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 21:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E848824844
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 21:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559598455;
	bh=n9SyFEz1scq0F+hulkDOofWavK0RVDUzt5KbFhVJxXU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=F6cP0vJY/hhnE+KYY79qEWz++nbS8Y/zxJbKGIBA6pVS9WR7dqaR4Qq5H/FpJoJIv
	 6er4DV5k4op8hiyQxg8gBa1yRtX3JkYqnUI6dEUgSGwLPyRDQcXbas2+NsC87/R781
	 fLJhsjjYDT19ib7sqXZ9p8Mx94hF2m+Eb548y1Lo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFCVra (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 17:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbfFCVr0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 17:47:26 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF4D2465C
        for <linux-sgx@vger.kernel.org>; Mon,  3 Jun 2019 21:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559597851;
        bh=n9SyFEz1scq0F+hulkDOofWavK0RVDUzt5KbFhVJxXU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wl+zxf1zXrXTscPd69no8f3com+w7DM1Ij9JSl6nzJEwn21nR1/vkX/KVRgO+NKi5
         HqAYbd2/RvghdNstiyg9ha1DYR41NNpT/hot0tEZcFGgwBDLilwmu/lIQ6aGvQ7kRp
         XYe9TujRyGiqLtBNWH6Yz4U1SacrGQimo6MS5eD0=
Received: by mail-wm1-f41.google.com with SMTP id 22so4374759wmg.2
        for <linux-sgx@vger.kernel.org>; Mon, 03 Jun 2019 14:37:30 -0700 (PDT)
X-Gm-Message-State: APjAAAWTGZ7bnziNUd0CRsdcpSSPQ0C1IA1ri6tJc/1xGqaGctZkWOU1
        mmVPh7TsdpO2yhpf4ohkmNTv/uPYe1NvqvbsariuQg==
X-Google-Smtp-Source: APXvYqxdUr7TDIteSerX6UkuNzjBgbrWWlCpsdbDlcFwObi9TtMlsj3g3nDpINh3WF26sC6Rc/305H4m02M04UFf+ic=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr9098862wme.173.1559597849219;
 Mon, 03 Jun 2019 14:37:29 -0700 (PDT)
MIME-Version: 1.0
References: <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com> <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
 <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov> <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
 <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov> <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
 <20190603205405.GE4894@linux.intel.com>
In-Reply-To: <20190603205405.GE4894@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 Jun 2019 14:37:17 -0700
X-Gmail-Original-Message-ID: <CALCETrVS15kAsD9mko9sreyZ8uciiOfOpnMabcQr4_3jE-npNA@mail.gmail.com>
Message-ID: <CALCETrVS15kAsD9mko9sreyZ8uciiOfOpnMabcQr4_3jE-npNA@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 3, 2019 at 1:54 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Thu, May 30, 2019 at 09:14:10AM -0700, Andy Lutomirski wrote:
> > > What is the "source file" i.e. the target of the check?  Enclave file,
> > > sigstruct file, or /dev/sgx/enclave?
> >
> > Enclave file -- that is, the file backing the vma from which the data
> > is loaded.
>
> Wonder why KVM gets away without having this given that enclaves are
> lot alike VMs.
>

I would argue it's because access to /dev/kvm means you can execute
whatever you code you want in a VM.  I don't see how this is
avoidable. On the other hand, it would be nice for SGX to not imply
this same sort of "execute anything" right, especially since, unlike
KVM, SGX is not a sandbox.
