Return-Path: <SRS0=8byu=O7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C45C43387
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Dec 2018 00:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3BEA21928
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Dec 2018 00:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404017AbeLVAB5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 19:01:57 -0500
Received: from mga05.intel.com ([192.55.52.43]:41421 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729993AbeLVAB5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 19:01:57 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 16:01:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="129875464"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by fmsmga004.fm.intel.com with ESMTP; 21 Dec 2018 16:01:46 -0800
Date:   Sat, 22 Dec 2018 02:01:45 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>, X86 ML <x86@kernel.org>,
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
Message-ID: <20181222000145.GA8954@linux.intel.com>
References: <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <20181217222047.GG12491@linux.intel.com>
 <CALCETrX1HXZvMk8UM6wV5StTj+vvqehAvybJYk66At60t91QGQ@mail.gmail.com>
 <20181218154417.GC28326@linux.intel.com>
 <20181218185349.GC30082@linux.intel.com>
 <20181219050047.GC14295@linux.intel.com>
 <20181221182809.GB27371@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181221182809.GB27371@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 21, 2018 at 10:28:09AM -0800, Sean Christopherson wrote:
> > Why would you want to pass EPC through user space to KVM rather than
> > KVM allocating it through kernel interfaces?
> 
> Delegating EPC management to userspace fits better with KVM's existing
> memory ABI.  KVM provides a single ioctl(), KVM_SET_USER_MEMORY_REGION[1],
> that allows userspace to create, move, modify and delete memory regions.
> 
> Skipping over a lot of details, there are essentially three options for
> exposing EPC to a KVM guest:
> 
>  1) Provide a dedicated KVM ioctl() to manage EPC without routing it
>     through KVM_SET_USER_MEMORY_REGION.
> 
>  2) Add a flag to 'struct kvm_userspace_memory_region' that denotes an
>     EPC memory region and mmap() / allocate EPC in KVM.
> 
>  3) Provide an ABI to allocate raw EPC and let userspace manage it like
>     any other memory region.
> 
> Option (1) requires duplicating all of KVM_SET_USER_MEMORY_REGION's
> functionality unless the ioctl() is severly restricted.
> 
> Option (2) is an ugly abuse of KVM_SET_USER_MEMORY_REGION since the EPC
> flag would have completely different semantics than all other usage of
> KVM_SET_USER_MEMORY_REGION.
> 
> Thus, option (3).

OK, thank you for patience explaining this.

> Probably a better question to answer is why provide the ABI through
> /dev/sgx and not /dev/kvm.  IMO /dev/sgx is a more logical way to
> advertise support to userspace, e.g. userspace can simply check if
> /dev/sgx (or /dev/sgx/epc) exists vs. probing a KVM capability.

You have to understand that for a KVM non-expert like me it was really
important to get the context, which you kindly gave. I have never used
KVM's memory management API but now that I know how it works all of this
makes perfect sense. This is not a better question but it is definitely
a good follow up question :-)

I don't really understand you deduction here, however. If SGX was not
supported, why couldn't the hypothetical /dev/kvm functionality just
return an error?

For me it sounds a bit messy that KVM functionality, which is a client
to the SGX functionality, places some of its functionality to the SGX
core.

/Jarkko
