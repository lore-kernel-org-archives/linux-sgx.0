Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A6AC43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 18:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2DD721873
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 18:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbeLRSxv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 13:53:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:20846 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbeLRSxv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 13:53:51 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 10:53:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,368,1539673200"; 
   d="scan'208";a="108376886"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by fmsmga007.fm.intel.com with ESMTP; 18 Dec 2018 10:53:49 -0800
Date:   Tue, 18 Dec 2018 10:53:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181218185349.GC30082@linux.intel.com>
References: <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <20181217222047.GG12491@linux.intel.com>
 <CALCETrX1HXZvMk8UM6wV5StTj+vvqehAvybJYk66At60t91QGQ@mail.gmail.com>
 <20181218154417.GC28326@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218154417.GC28326@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 18, 2018 at 07:44:18AM -0800, Sean Christopherson wrote:
> On Mon, Dec 17, 2018 at 08:59:54PM -0800, Andy Lutomirski wrote:
> > On Mon, Dec 17, 2018 at 2:20 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > 
> > > My brain is still sorting out the details, but I generally like the idea
> > > of allocating an anon inode when creating an enclave, and exposing the
> > > other ioctls() via the returned fd.  This is essentially the approach
> > > used by KVM to manage multiple "layers" of ioctls across KVM itself, VMs
> > > and vCPUS.  There are even similarities to accessing physical memory via
> > > multiple disparate domains, e.g. host kernel, host userspace and guest.
> > >
> > 
> > In my mind, opening /dev/sgx would give you the requisite inode.  I'm
> > not 100% sure that the chardev infrastructure allows this, but I think
> > it does.
> 
> My fd/inode knowledge is lacking, to say the least.  Whatever works, so
> long as we have a way to uniquely identify enclaves.

Actually, while we're dissecting the interface...

What if we re-organize the ioctls in such a way that we leave open the
possibility of allocating raw EPC for KVM via /dev/sgx?  I'm not 100%
positive this approach will work[1], but conceptually it fits well with
KVM's memory model, e.g. KVM is aware of the GPA<->HVA association but
generally speaking doesn't know what's physically backing each memory
region.

Tangentially related, I think we should support allocating multiple
enclaves from a single /dev/sgx fd, i.e. a process shouldn't have to
open /dev/sgx every time it wants to create a new enclave.

Something like this:

/dev/sgx
  |
  -> mmap() { return -EINVAL; }
  |
  -> unlocked_ioctl()
     |
     -> SGX_CREATE_ENCLAVE: { return alloc_enclave_fd(); }
     |  |
     |   -> mmap() { ... }
     |  | 
     |   -> get_unmapped_area() { 
     |  |           if (enclave->size) {
     |  |                   if (!addr)
     |  |                           addr = enclave->base;
     |  |                   if (addr + len + pgoff > enclave->base + enclave->size)
     |  |                           return -EINVAL;
     |  |           } else {
     |  |                   if (!validate_size(len))
     |  |                           return -EINVAL;
     |  |                   addr = naturally_align(len);
     |  |           }
     |  |   }
     |  |
     |   -> unlocked_ioctl() {
     |              SGX_ENCLAVE_ADD_PAGE: { ... }
     |              SGX_ENCLAVE_INIT: { ... }
     |              SGX_ENCLAVE_REMOVE_PAGES: { ... }
     |              SGX_ENCLAVE_MODIFY_PAGES: { ... }
     |      }
     |
     -> SGX_CREATE_VIRTUAL_EPC: {return alloc_epc_fd(); }
        |
         -> mmap() { ... }
        |
	 -> get_unmapped_area() {<page aligned/sized> }
        |
         -> unlocked_ioctl() {
                    SGX_VIRTUAL_EPC_???:
		    SGX_VIRTUAL_EPC_???:
	    }


[1] Delegating EPC management to /dev/sgx is viable for virtualizing SGX
    without oversubscribing EPC to guests, but oversubscribing EPC in a
    VMM requires handling EPC-related VM-Exits and using instructions
    that will #UD if the CPU is not post-VMXON.  I *think* having KVM
    forward VM-Exits to x86/sgx would work, but it's entirely possible
    it'd be a complete cluster.
