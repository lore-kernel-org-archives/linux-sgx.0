Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B6DC43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 14:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AE6E218AE
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 14:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbeLSOpQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 09:45:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:55084 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbeLSOpQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 09:45:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 06:45:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,373,1539673200"; 
   d="scan'208";a="102875924"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga008.jf.intel.com with ESMTP; 19 Dec 2018 06:45:15 -0800
Date:   Wed, 19 Dec 2018 06:45:15 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181219144515.GA30909@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 19, 2018 at 09:36:16AM +0000, Jethro Beekman wrote:
> On 2018-12-19 14:41, Jarkko Sakkinen wrote:
> >On Wed, Dec 19, 2018 at 08:41:12AM +0000, Jethro Beekman wrote:
> >>One weird thing is the departure from the normal mmap behavior that the
> >>memory mapping persists even if the original fd is closed. (See man mmap:
> >>"closing the file descriptor does not unmap the region.")

It won't (be a departure).  mmap() on a file grabs a reference to the
file, i.e. each VMA keeps a reference to the file.  Closing the original
enclave fd will only put its reference to the file/enclave, not destroy
it outright.

> >
> >The mmapped region and enclave would be completely disjoint to start
> >with. The enclave driver code would assume that an enclave VMA exists
> >when it maps enclave address space to a process.
> >
> >I.e. VMA would no longer reference to the enclave or vice versa but
> >you would still create an enclave VMA with mmap().
> >
> >This is IMHO very clear and well-defined semantics.
> >
> >>>struct sgx_enclave_add_page {
> >>>	__u64	enclave_fd;
> >>>	__u64	src;
> >>>	__u64	secinfo;
> >>>	__u16	mrmask;
> >>>} __attribute__((__packed__));
> >>
> >>Wouldn't you just pass enclave_fd as the ioctl fd parameter?
> >
> >I'm still planning to keep the API in the device fd and use enclave_fd
> >as handle to the enclave address space. I don't see any obvious reason
> >to change that behavior.
> >
> >And if we ever add any "global" ioctls, then we would have to define
> >APIs to both fd's, which would become a mess.
> >
> >>How to specify the address of the page that is being added?
> >
> >Yes, that is correct and my bad to remove it (just quickly drafted what
> >I had in mind).
> 
> So your plan is that to call EADD, userspace has to pass the device fd AND
> the enclave fd AND the enclave address? That seems a little superfluous.

I agree with Jethro, passing the enclave_fd as a param is obnoxious.
And it means the user needs to open /dev/sgx to do anything with an
enclave fd, e.g. the enclave fd might be passed to a builder thread,
it shouldn't also need the device fd.

E.g.:

	sgx_fd = open("/dev/sgx", O_RDWR);
	BUG_ON(sgx_fd < 0);

	enclave_fd = ioctl(sgx_fd, SGX_ENCLAVE_CREATE, &ecreate);
	BUG_ON(enclave_fd < 0);

	ret = ioctl(enclave_fd, SGX_ENCLAVE_ADD_PAGE, &eadd);
	BUG_ON(ret);

	...

	ret = ioctl(enclave_fd, SGX_ENCLAVE_INIT, &einit);
	BUG_ON(ret);

	...

	close(enclave_fd);
	close(sgx_fd);


Take a look at virt/kvm/kvm_main.c to see how KVM manages anon inodes
and ioctls for VMs and vCPUs.
