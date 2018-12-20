Return-Path: <SRS0=1Eyi=O5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD663C43387
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 02:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83249217D9
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 02:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545274743;
	bh=iGdGEXSLYKpXBlSfgEdCCW99gLqSH/g6t/h8EZuf/+M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=WeFUABNr0I2JPZM3P5Tbl1r8wvvjipb5xlfYcFcur7piLPdsgxubXxPqT6OZkWZ2T
	 a0/jWhWWEXqUQLBrT5WGiiNgLvcDGer+P2wpurhb6Z6CcyLnApWqf3ocxpqPsbZ8ng
	 AXwL5yy1Rz0bhLH4Ad8ijrYL/qTmUBU/vjQJ3OxM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbeLTC7C (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 21:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbeLTC7C (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 21:59:02 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B58218C3
        for <linux-sgx@vger.kernel.org>; Thu, 20 Dec 2018 02:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545274741;
        bh=iGdGEXSLYKpXBlSfgEdCCW99gLqSH/g6t/h8EZuf/+M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PcFyA7H0dGzszd8FLZLLpkKINtgrlILAHurbhWSCC21lOuS1LJ5t6Dy90ARECri4X
         kukOLTO2zRU6+jR4CnMNyU9RuMZQai/UM2liZ7YQTBmwAQjEggek5ou7a2FklweQiY
         gO7ncum+fkpHK2YV0aK7OPRDvteumvt6XfOSrFag=
Received: by mail-wm1-f46.google.com with SMTP id a62so432447wmh.4
        for <linux-sgx@vger.kernel.org>; Wed, 19 Dec 2018 18:59:01 -0800 (PST)
X-Gm-Message-State: AA+aEWYpbbr+A+M5gMOaCahg60BDoLWm1VGYZzJEHIOB5pAIbY9K7kn4
        yGcg5olkOczT47ykzzS0xVGtGbpNcX1KPvyjfTln0w==
X-Google-Smtp-Source: AFSGD/VKTSmCT33JlFIzalN/D/WwM7YvVauXKlAk3SBSsLoNhcDBleVrjq2ThmnPfpzFJ0H0NzLpJzowxNHuFGCKZ/U=
X-Received: by 2002:a1c:864f:: with SMTP id i76mr9172581wmd.83.1545274739990;
 Wed, 19 Dec 2018 18:58:59 -0800 (PST)
MIME-Version: 1.0
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com> <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com> <20181219144515.GA30909@linux.intel.com>
In-Reply-To: <20181219144515.GA30909@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 19 Dec 2018 18:58:48 -0800
X-Gmail-Original-Message-ID: <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
Message-ID: <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
Subject: Re: x86/sgx: uapi change proposal
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Dec 19, 2018, at 6:45 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>
>> On Wed, Dec 19, 2018 at 09:36:16AM +0000, Jethro Beekman wrote:

> I agree with Jethro, passing the enclave_fd as a param is obnoxious.
> And it means the user needs to open /dev/sgx to do anything with an
> enclave fd, e.g. the enclave fd might be passed to a builder thread,
> it shouldn't also need the device fd.
>
> E.g.:
>
>    sgx_fd = open("/dev/sgx", O_RDWR);
>    BUG_ON(sgx_fd < 0);
>
>    enclave_fd = ioctl(sgx_fd, SGX_ENCLAVE_CREATE, &ecreate);
>    BUG_ON(enclave_fd < 0);
>
>    ret = ioctl(enclave_fd, SGX_ENCLAVE_ADD_PAGE, &eadd);
>    BUG_ON(ret);
>
>    ...
>
>    ret = ioctl(enclave_fd, SGX_ENCLAVE_INIT, &einit);
>    BUG_ON(ret);
>
>    ...
>
>    close(enclave_fd);
>    close(sgx_fd);
>
>
> Take a look at virt/kvm/kvm_main.c to see how KVM manages anon inodes
> and ioctls for VMs and vCPUs.

Can one of you explain why SGX_ENCLAVE_CREATE is better than just
opening a new instance of /dev/sgx for each encalve?
