Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16155C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 18:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0FEE2190A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 18:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391377AbeLUSY4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 13:24:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:31912 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388745AbeLUSY4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 13:24:56 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 10:24:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,382,1539673200"; 
   d="scan'208";a="131949895"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga001.fm.intel.com with ESMTP; 21 Dec 2018 10:24:54 -0800
Date:   Fri, 21 Dec 2018 10:24:54 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jethro Beekman <jethro@fortanix.com>,
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
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181221182454.GA27371@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 21, 2018 at 09:12:46AM -0800, Andy Lutomirski wrote:
> > On Dec 21, 2018, at 9:28 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >
> > On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
> >>> On Dec 19, 2018, at 6:45 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> >>>
> >>>>> On Wed, Dec 19, 2018 at 09:36:16AM +0000, Jethro Beekman wrote:
> >>>
> >>> I agree with Jethro, passing the enclave_fd as a param is obnoxious.
> >>> And it means the user needs to open /dev/sgx to do anything with an
> >>> enclave fd, e.g. the enclave fd might be passed to a builder thread,
> >>> it shouldn't also need the device fd.
> >>>
> >>> E.g.:
> >>>
> >>>   sgx_fd = open("/dev/sgx", O_RDWR);
> >>>   BUG_ON(sgx_fd < 0);
> >>>
> >>>   enclave_fd = ioctl(sgx_fd, SGX_ENCLAVE_CREATE, &ecreate);
> >>>   BUG_ON(enclave_fd < 0);
> >>>
> >>>   ret = ioctl(enclave_fd, SGX_ENCLAVE_ADD_PAGE, &eadd);
> >>>   BUG_ON(ret);
> >>>
> >>>   ...
> >>>
> >>>   ret = ioctl(enclave_fd, SGX_ENCLAVE_INIT, &einit);
> >>>   BUG_ON(ret);
> >>>
> >>>   ...
> >>>
> >>>   close(enclave_fd);
> >>>   close(sgx_fd);
> >>>
> >>>
> >>> Take a look at virt/kvm/kvm_main.c to see how KVM manages anon inodes
> >>> and ioctls for VMs and vCPUs.
> >>
> >> Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> >> opening a new instance of /dev/sgx for each encalve?
> >
> > Directly associating /dev/sgx with an enclave means /dev/sgx can't be
> > used to provide ioctl()'s for other SGX-related needs, e.g. to mmap()
> > raw EPC and expose it a VM.  Proposed layout in the link below.  I'll
> > also respond to Jarkko's question about exposing EPC through /dev/sgx
> > instead of having KVM allocate it on behalf of the VM.
> 
> Hmm. I guess this makes some sense.  My instinct would be to do it a
> little differently and have:
> 
> /dev/sgx/enclave: Each instance is an enclave.
> 
> /dev/sgx/epc: Used to get raw EPC for KVM. Might have different
> permissions, perhaps 0660 and group kvm.
> 
> /dev/sgx/something_else: For when SGX v3 adds something else :)

Mmmm, I like this approach a lot.  It would allow userspace to easily
manage permissions for each "feature", e.g. give all users access to
/dev/sgx/epc but restrict /dev/sgx/enclave.

And we could add e.g. /dev/sgx/admin if we wanted to exposed ioctls()
that apply to all aspects of SGX.

Do you know if /dev/sgx/epc could be dynamically created, e.g. by
KVM when the kvm_intel module is loaded?  That would seal the deal for
me as it'd keep open the option of having KVM handle oversubscription
of guest EPC while exposing EPC through /dev/sgx instead of /dev/kvm.  
