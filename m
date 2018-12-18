Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDB5C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 01:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53DCB2145D
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 01:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbeLRBRh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 20:17:37 -0500
Received: from mga05.intel.com ([192.55.52.43]:44237 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbeLRBRh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 20:17:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 17:17:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,367,1539673200"; 
   d="scan'208";a="102300805"
Received: from unknown (HELO localhost) ([10.249.254.218])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2018 17:17:26 -0800
Date:   Tue, 18 Dec 2018 03:17:25 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20181218011725.GA333@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 11:12:21AM -0800, Andy Lutomirski wrote:
> I'm going to ask an obnoxious high-level question: why does an enclave
> even refer to a specific mm?

The reason is that it has not been yet in focus in the review process
and there has been other concerns.

At least the code is fairly stable i.e. working code is usually good
starting point for making something different (ignoring the recent
regression caused by the shmem to VMA migration).

> If I were designing this thing, and if I hadn't started trying to
> implement it, my first thought would be that an enclave tracks its
> linear address range, which is just a pair of numbers, and also keeps
> track of a whole bunch of physical EPC pages, data structures, etc.
> And that mmap() gets rejected unless the requested virtual address
> matches the linear address range that the enclave wants and, aside
> from that, just creates a VMA that keeps a reference to the enclave.
> (And, for convenience, I suppose that the first mmap() call done
> before any actual enclave setup happens could choose any address and
> then cause the enclave to lock itself to that address, although a
> regular anonymous PROT_NONE MAP_NORESERVE mapping would do just fine,
> too.)  And the driver would explicitly allow multiple different mms to
> have the same enclave mapped.  More importantly, a daemon could set up
> an enclave without necessarily mapping it at all and then SCM_RIGHTS
> the enclave over to the process that plans to run it.

The current SGX_IOC_ENCLAVE_CREATE ioctl would be trivial to change to
use this approach. Instead looking up VMA with an enclave instance it
would create a new enclave instance.

Then we could have SGX_IOC_ENCLAVE_ATTACH to attach an enclave to a VMA.

This does not sound too complicated.

> Now I'm sure this has all kinds of problems, such as the ISA possibly
> making it rather obnoxious to add pages to the enclave without having
> it mapped.  But these operations could, in principle, be done by

We do EADD in a kthread. What this would require to put current->mm
into a request that it is processed by that thread. This would be
doable with mmget().

The deadlock that Sean mentioned would not exist since closing VMAs
is not bounded to the enclave life-cycle anymore.

So at least non-swapping ISA is easy to fit to this framework. I can
rework this for v19.

/Jarkko
