Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF33C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 17:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C10D21917
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545412426;
	bh=NKQ6Ta8Xhq9H9Ht4qiyj2z49nx9fCRA+nd/VKc96BM8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NVtGVvRt6jMnkfj/QR35M4/GGNOPdyIlADGNEPBL7Qrgva0wF0CruwqDi9SRBDZJa
	 izkyLNWmXDz0c8saUInfll9IyscqNX94JmgvAOO2BvVRhB3qNLeY53pX0zKuIA3ok1
	 N1adyMXqyB36c3RlAWA1epgncJzlhXailrXFbjQg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731814AbeLURNq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 12:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730721AbeLURNq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 12:13:46 -0500
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7396621972
        for <linux-sgx@vger.kernel.org>; Fri, 21 Dec 2018 17:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545412424;
        bh=NKQ6Ta8Xhq9H9Ht4qiyj2z49nx9fCRA+nd/VKc96BM8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=plkoMWCRqC42eYyk/0BVbfjWjqyZ12LwZ//E5/uPTjygUhnpIWiVpbLq5EtF5iePK
         kVTr7QyT7jHboyZCElLvCB0GbgT1smUhRehGBEA55j20bnTo44TeI8XE9zgh8EhNiV
         TFF3whg7zEFEpdbpzyKyvPKWYv7V1KKjrc/DWHtI=
Received: by mail-wm1-f41.google.com with SMTP id f188so6403941wmf.5
        for <linux-sgx@vger.kernel.org>; Fri, 21 Dec 2018 09:13:44 -0800 (PST)
X-Gm-Message-State: AJcUukf1EFnK4lTAyHiibzs7gGUIs+iHz+gXmZuWxEjVqrpP0lyrxHbd
        7o2Uh6eA11RtXOweuJjN9FJt7VbW5c9J3PcQEKw4xw==
X-Google-Smtp-Source: ALg8bN5TPVxOitsE0z/AfTkC4owWbl/lGgH0Z3zAfOVWsR2wyz0u4TAGpfPtVSinDiLzRvLw2ITyDZug2GzCRVpl1dk=
X-Received: by 2002:a7b:c7c7:: with SMTP id z7mr3854825wmk.74.1545412422919;
 Fri, 21 Dec 2018 09:13:42 -0800 (PST)
MIME-Version: 1.0
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com> <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com> <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com> <20181221162825.GB26865@linux.intel.com>
In-Reply-To: <20181221162825.GB26865@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Fri, 21 Dec 2018 09:12:46 -0800
X-Gmail-Original-Message-ID: <CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com>
Message-ID: <CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com>
Subject: Re: x86/sgx: uapi change proposal
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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

> On Dec 21, 2018, at 9:28 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>
> On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
>>> On Dec 19, 2018, at 6:45 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>>
>>>>> On Wed, Dec 19, 2018 at 09:36:16AM +0000, Jethro Beekman wrote:
>>>
>>> I agree with Jethro, passing the enclave_fd as a param is obnoxious.
>>> And it means the user needs to open /dev/sgx to do anything with an
>>> enclave fd, e.g. the enclave fd might be passed to a builder thread,
>>> it shouldn't also need the device fd.
>>>
>>> E.g.:
>>>
>>>   sgx_fd = open("/dev/sgx", O_RDWR);
>>>   BUG_ON(sgx_fd < 0);
>>>
>>>   enclave_fd = ioctl(sgx_fd, SGX_ENCLAVE_CREATE, &ecreate);
>>>   BUG_ON(enclave_fd < 0);
>>>
>>>   ret = ioctl(enclave_fd, SGX_ENCLAVE_ADD_PAGE, &eadd);
>>>   BUG_ON(ret);
>>>
>>>   ...
>>>
>>>   ret = ioctl(enclave_fd, SGX_ENCLAVE_INIT, &einit);
>>>   BUG_ON(ret);
>>>
>>>   ...
>>>
>>>   close(enclave_fd);
>>>   close(sgx_fd);
>>>
>>>
>>> Take a look at virt/kvm/kvm_main.c to see how KVM manages anon inodes
>>> and ioctls for VMs and vCPUs.
>>
>> Can one of you explain why SGX_ENCLAVE_CREATE is better than just
>> opening a new instance of /dev/sgx for each encalve?
>
> Directly associating /dev/sgx with an enclave means /dev/sgx can't be
> used to provide ioctl()'s for other SGX-related needs, e.g. to mmap()
> raw EPC and expose it a VM.  Proposed layout in the link below.  I'll
> also respond to Jarkko's question about exposing EPC through /dev/sgx
> instead of having KVM allocate it on behalf of the VM.

Hmm. I guess this makes some sense.  My instinct would be to do it a
little differently and have:

/dev/sgx/enclave: Each instance is an enclave.

/dev/sgx/epc: Used to get raw EPC for KVM. Might have different
permissions, perhaps 0660 and group kvm.

/dev/sgx/something_else: For when SGX v3 adds something else :)
