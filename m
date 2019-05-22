Return-Path: <SRS0=b5m/=TW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CBCC282DD
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 15:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19071208C3
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 15:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729555AbfEVPii (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 May 2019 11:38:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:48153 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbfEVPii (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 May 2019 11:38:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 08:38:37 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga001.jf.intel.com with ESMTP; 22 May 2019 08:38:36 -0700
Date:   Wed, 22 May 2019 08:38:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190522153836.GA24833@linux.intel.com>
References: <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190517000331.GD11204@linux.intel.com>
 <CALCETrWxw7xALE0kmiYBzomaSMAeXEVq-7rX7xeqPtDPeDQiCA@mail.gmail.com>
 <20190520114105.GD27805@linux.intel.com>
 <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 22, 2019 at 09:56:30AM -0400, Stephen Smalley wrote:
> On 5/22/19 9:22 AM, Jarkko Sakkinen wrote:
> >On Wed, May 22, 2019 at 04:20:22PM +0300, Jarkko Sakkinen wrote:
> >>On Tue, May 21, 2019 at 08:51:40AM -0700, Sean Christopherson wrote:
> >>>Except that mmap() is more or less required to guarantee that ELRANGE
> >>>established by ECREATE is available.  And we want to disallow mmap() as
> >>>soon as the first EADD is done so that userspace can't remap the enclave's
> >>>VMAs via munmap()->mmap() and gain execute permissions to pages that were
> >>>EADD'd as NX.
> >>
> >>We don't want to guarantee such thing and it is not guaranteed. It does
> >>not fit at all to the multi process work done. Enclaves are detached
> >>from any particular process addresse spaces. It is responsibility of
> >>process to open windows to them.
> >>
> >>That would be completely against work that we've done lately.
> >
> >Example use case: you have a process that just constructs an enclave
> >and sends it to another process or processes for use. The constructor
> >process could have basically anything on that range. This was the key
> >goal of the fd based enclave work.
> 
> What exactly happens in the constructor versus the recipient processes?
> Which process performs each of the necessary open(), mmap(), and ioctl()
> calls for setting up the enclave?  Can you provide a high level overview of
> the sequence of userspace calls by the constructor and by the recipient
> similar to what Sean showed earlier for just a single process?

Hmm, what we had talked about was allowing the SGX ioctls to work without
an associated VMA, with the end goal of letting userspace restrict access
to /dev/sgx/enclave.   Very roughly...

Enclave Owner:

  connect(builder, ...);
  send(builder, "/home/sean/path/to/my/enclave");

  recv(builder, &enclave_fd);

  for_each_chunk {
          mmap(enclave_addr + offset, size, ..., MAP_SHARED, enclave_fd, 0);
  }
  

Enclave Builder:

  recv(sock, &enclave_path);

  source_fd = open(enclave_path, O_RDONLY);
  for_each_chunk {
          <hand waving - mmap()/mprotect() the enclave file into regular memory>
  }

  enclave_fd = open("/dev/sgx/enclave", O_RDWR);

  ioctl(enclave_fd, ENCLAVE_CREATE, ...);
  for_each_chunk {
      struct sgx_enclave_add ioctlargs = {
          .offset = chunk.offset,
          .source = chunk.addr,
          .size   = chunk.size,
          .type   = chunk.type, /* SGX specific metadata */
      }
      ioctl(fd, ENCLAVE_ADD, &ioctlargs); /* modifies enclave's VMAs */
  }
  ioctl(enclave_fd, ENCLAVE_INIT, ...);

  write(sock, enclave_fd);


But the above flow is flawed because there'a catch-22: ENCLAVE_ECREATE
takes the virtual address of the enclave, but in the above flow that's
not established until "mmap(..., enclave_fd)".  And because an enclave's
virtual range needs to be naturally aligned (hardware requirements), the
enclave owner would need to do something like:

  source_fd = open("/home/sean/path/to/my/enclave", O_RDONLY);
  size = <parse size from source_fd>
  
  enclave_range = mmap(NULL, size*2, PROT_READ, ???, NULL, 0);
  enclave_addr = (enclave_range + (size - 1)) & ~(size - 1);

  connect(builder, ...);
  send(builder, {"/home/sean/path/to/my/enclave", enclave_addr});

  recv(builder, &enclave_fd);

  munmap(enclave_range);

  for_each_chunk {
      addr = mmap(enclave_addr + c.offset, c.size, ..., MAP_SHARED, enclave_fd, 0);
      if (addr != enclave_addr + c.offset)
           exit(1);
  } 

And that straight up doesn't work with the v20 driver because mmap() with
the enclave_fd will run through sgx_get_unmapped_area(), which also does
the natural alignment adjustments (the idea being that mmap() is mapping
the entire enclave).  E.g. mmap() will map the wrong address if the offset
of a chunk is less than its size due to the driver adjusting the address.

Eliminating sgx_get_unmapped_area() means userspace is once again on the
hook for naturally aligning the enclave, which is less than desirable.

Looking back at the original API discussions around a builder process[1],
we never fleshed out the end-to-end flow.  While having a builder process
*sounds* reasonable, in practice it adds a lot of complexity without
providing much in the way of added security.  E.g. in addition to the
above mmap() issues, since the order of EADDs affects the enclave
measurement, the enclave owner would need to communicate the exact steps
to build the enclave, or the builder would need a priori knowledge of the
enclave format.

Userspace can still restrict access to /dev/sgx/enclave, e.g. by having a
daemon that requires additional credentials to obtain a new enclave_fd.
So AFAICT, the only benefit to having a dedicated builder is that it can
do its own whitelisting of enclaves, but since we're trending towards
supporting whitelisting enclaves in the kernel, e.g. via sigstruct,
whitelisting in userspace purely in userspace also provides marginal value.

TL;DR: Requiring VMA backing to build an enclave seems reasonable and sane.

[1] https://lkml.kernel.org/r/CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com
