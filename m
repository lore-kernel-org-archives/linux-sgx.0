Return-Path: <SRS0=b5m/=TW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C15C282DC
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 22:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8987217D4
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 22:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558564982;
	bh=OOvk4jhd4RJaf/SM5z16pjS8vJ3csmmntOLya71ImTY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=b2Am/hRCv6GD3JfGU0aqNrFea/POlJmzBOZBeE+Pg2Zl0JtYA9YCdmJl2yVpPSg0O
	 sc5OYU7MGMekmf7Nj3gCjGU+czpjNFzt2PIpkEDLtLH+oQ5RvBYFr5lBo19vhffsA7
	 jaXJtKvzdha6tpv76jeT7/MZff1fiUhpGq16s2VI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfEVWnC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 May 2019 18:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbfEVWnB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 May 2019 18:43:01 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE03F21880
        for <linux-sgx@vger.kernel.org>; Wed, 22 May 2019 22:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558564980;
        bh=OOvk4jhd4RJaf/SM5z16pjS8vJ3csmmntOLya71ImTY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fkg4CzRt3KfZIIuwZhzbASPWvQne1uPmtkXgLmrH+CuFZiOEi0zLUesjMgrKV+ora
         88HzrAaito+YpfExzVyeervxBjvfQAK10ve1IiDm6qcCvmuw+Y0q2xdQXcej1zFFpV
         umLRTRjkuW63RJy2VgP3ARN7C7MQfYfiO48A6VvQ=
Received: by mail-wm1-f51.google.com with SMTP id i3so3783186wml.4
        for <linux-sgx@vger.kernel.org>; Wed, 22 May 2019 15:42:59 -0700 (PDT)
X-Gm-Message-State: APjAAAWEdfFoDIDmgfgZFaF9OLTaWpSavAVtNclaNzqZiLTviMeNS2U0
        CQXLmArh2dMc+xA8b7DZ0aCMHrs0C8+0rGHiqXdojw==
X-Google-Smtp-Source: APXvYqzYdSH+GPYlXRlgnwW11c6pqXd9fEL34pkzWbjIju7c8aUW1zezZ1OS5qIiYrcgg2q8tcuDWDAEMZ3zzBaU0WE=
X-Received: by 2002:a1c:4107:: with SMTP id o7mr9456931wma.122.1558564978244;
 Wed, 22 May 2019 15:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190517000331.GD11204@linux.intel.com> <CALCETrWxw7xALE0kmiYBzomaSMAeXEVq-7rX7xeqPtDPeDQiCA@mail.gmail.com>
 <20190520114105.GD27805@linux.intel.com> <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com> <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com> <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
In-Reply-To: <20190522153836.GA24833@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 22 May 2019 15:42:45 -0700
X-Gmail-Original-Message-ID: <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
Message-ID: <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
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

On Wed, May 22, 2019 at 8:38 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, May 22, 2019 at 09:56:30AM -0400, Stephen Smalley wrote:
> > On 5/22/19 9:22 AM, Jarkko Sakkinen wrote:
> > >On Wed, May 22, 2019 at 04:20:22PM +0300, Jarkko Sakkinen wrote:
> > >>On Tue, May 21, 2019 at 08:51:40AM -0700, Sean Christopherson wrote:
> > >>>Except that mmap() is more or less required to guarantee that ELRANGE
> > >>>established by ECREATE is available.  And we want to disallow mmap() as
> > >>>soon as the first EADD is done so that userspace can't remap the enclave's
> > >>>VMAs via munmap()->mmap() and gain execute permissions to pages that were
> > >>>EADD'd as NX.
> > >>
> > >>We don't want to guarantee such thing and it is not guaranteed. It does
> > >>not fit at all to the multi process work done. Enclaves are detached
> > >>from any particular process addresse spaces. It is responsibility of
> > >>process to open windows to them.
> > >>
> > >>That would be completely against work that we've done lately.
> > >
> > >Example use case: you have a process that just constructs an enclave
> > >and sends it to another process or processes for use. The constructor
> > >process could have basically anything on that range. This was the key
> > >goal of the fd based enclave work.
> >
> > What exactly happens in the constructor versus the recipient processes?
> > Which process performs each of the necessary open(), mmap(), and ioctl()
> > calls for setting up the enclave?  Can you provide a high level overview of
> > the sequence of userspace calls by the constructor and by the recipient
> > similar to what Sean showed earlier for just a single process?
>
> Hmm, what we had talked about was allowing the SGX ioctls to work without
> an associated VMA, with the end goal of letting userspace restrict access
> to /dev/sgx/enclave.   Very roughly...
>
> Enclave Owner:
>
>   connect(builder, ...);
>   send(builder, "/home/sean/path/to/my/enclave");
>
>   recv(builder, &enclave_fd);
>
>   for_each_chunk {
>           mmap(enclave_addr + offset, size, ..., MAP_SHARED, enclave_fd, 0);
>   }
>
>
> Enclave Builder:
>
>   recv(sock, &enclave_path);
>
>   source_fd = open(enclave_path, O_RDONLY);
>   for_each_chunk {
>           <hand waving - mmap()/mprotect() the enclave file into regular memory>
>   }
>
>   enclave_fd = open("/dev/sgx/enclave", O_RDWR);
>
>   ioctl(enclave_fd, ENCLAVE_CREATE, ...);
>   for_each_chunk {
>       struct sgx_enclave_add ioctlargs = {
>           .offset = chunk.offset,
>           .source = chunk.addr,
>           .size   = chunk.size,
>           .type   = chunk.type, /* SGX specific metadata */
>       }
>       ioctl(fd, ENCLAVE_ADD, &ioctlargs); /* modifies enclave's VMAs */
>   }
>   ioctl(enclave_fd, ENCLAVE_INIT, ...);
>
>   write(sock, enclave_fd);
>
>
> But the above flow is flawed because there'a catch-22: ENCLAVE_ECREATE
> takes the virtual address of the enclave, but in the above flow that's
> not established until "mmap(..., enclave_fd)".  And because an enclave's
> virtual range needs to be naturally aligned (hardware requirements), the
> enclave owner would need to do something like:
>
>   source_fd = open("/home/sean/path/to/my/enclave", O_RDONLY);
>   size = <parse size from source_fd>
>
>   enclave_range = mmap(NULL, size*2, PROT_READ, ???, NULL, 0);
>   enclave_addr = (enclave_range + (size - 1)) & ~(size - 1);
>
>   connect(builder, ...);
>   send(builder, {"/home/sean/path/to/my/enclave", enclave_addr});
>
>   recv(builder, &enclave_fd);
>
>   munmap(enclave_range);
>
>   for_each_chunk {
>       addr = mmap(enclave_addr + c.offset, c.size, ..., MAP_SHARED, enclave_fd, 0);
>       if (addr != enclave_addr + c.offset)
>            exit(1);
>   }
>
> And that straight up doesn't work with the v20 driver because mmap() with
> the enclave_fd will run through sgx_get_unmapped_area(), which also does
> the natural alignment adjustments (the idea being that mmap() is mapping
> the entire enclave).  E.g. mmap() will map the wrong address if the offset
> of a chunk is less than its size due to the driver adjusting the address.

That presumably needs to change.

Are we entirely missing an API to allocate a naturally aligned VA
range?  That's kind of annoying.

>
> Eliminating sgx_get_unmapped_area() means userspace is once again on the
> hook for naturally aligning the enclave, which is less than desirable.
>
> Looking back at the original API discussions around a builder process[1],
> we never fleshed out the end-to-end flow.  While having a builder process
> *sounds* reasonable, in practice it adds a lot of complexity without
> providing much in the way of added security.  E.g. in addition to the
> above mmap() issues, since the order of EADDs affects the enclave
> measurement, the enclave owner would need to communicate the exact steps
> to build the enclave, or the builder would need a priori knowledge of the
> enclave format.
>
> Userspace can still restrict access to /dev/sgx/enclave, e.g. by having a
> daemon that requires additional credentials to obtain a new enclave_fd.
> So AFAICT, the only benefit to having a dedicated builder is that it can
> do its own whitelisting of enclaves, but since we're trending towards
> supporting whitelisting enclaves in the kernel, e.g. via sigstruct,
> whitelisting in userspace purely in userspace also provides marginal value.
>
> TL;DR: Requiring VMA backing to build an enclave seems reasonable and sane.

This isn't necessarily a problem, but we pretty much have to use
mprotect() then.

Maybe the semantics could just be that mmap() on the SGX device gives
natural alignment, but that there is no actual constraint enforced by
the driver as to whether mmap() happens before or after ECREATE.
After all, it's *ugly* for user code to reserve its address range with
an awkward giant mmap(), there's nothing fundamentally wrong with it.

As far as I know from this whole discussion, we still haven't come up
with any credible way to avoid tracking, per enclave page, whether
that page came from unmodified PROT_EXEC memory.
