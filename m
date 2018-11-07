Return-Path: <SRS0=ssez=NS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85EEC0044C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Nov 2018 16:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B7032086C
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Nov 2018 16:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B7032086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbeKHCBg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Nov 2018 21:01:36 -0500
Received: from mga14.intel.com ([192.55.52.115]:51994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbeKHCBf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Nov 2018 21:01:35 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2018 08:30:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,476,1534834800"; 
   d="scan'208";a="84702378"
Received: from kaczmarx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.132])
  by fmsmga008.fm.intel.com with ESMTP; 07 Nov 2018 08:30:22 -0800
Date:   Wed, 7 Nov 2018 18:30:19 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com, andriy.shevchenko@linux.intel.com,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 23/23] x86/sgx: Driver documentation
Message-ID: <20181107163019.GA11509@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
 <20181106054911.GA15575@linux.intel.com>
 <e7b4c432-7005-308c-4da0-a80e0d294244@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7b4c432-7005-308c-4da0-a80e0d294244@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181107163019.JEJqspdakuWsb4-llLCUAeda2KoVAPujcENmaOT3-uw@z>

On Tue, Nov 06, 2018 at 08:45:37AM -0800, Dave Hansen wrote:
> On 11/5/18 9:49 PM, Jarkko Sakkinen wrote:
> > On Mon, Nov 05, 2018 at 12:27:11PM -0800, Dave Hansen wrote:
> >> The ABI seems entirely undocumented and rather lightly designed, which
> >> seems like something we should fix before this is merged.
> > 
> > ABI is documented in arch/x86/include/uapi/asm/sgx.h that from which the
> > documentation is included to intel_sgx.rst. I'm not saying that there is
> > no space refine it but it is neither undocumented.
> 
> I specifically mean the instruction flow around asynchronous exits or
> explicit enclave exit calls via EEXIT.  Signals are part of the ABI but
> go unmentioned in the documentation.

Ok, thanks for clarification. We will document it.
> 
> It's also worth noting that EENTER *can* act (from the kernel's
> perspective) like an instruction that both jumps and sets a bunch of
> registers (including %rsp).  It's certainly abnormal in that regard.

Agreed.

> In fact, in the docs:
> 
> > +Enclave can only execute code inside the ELRANGE. Instructions that may cause
> > +VMEXIT, IO instructions and instructions that require a privilege change are
> > +prohibited inside the enclave. Interrupts and exceptions always cause enclave
> > +to exit and jump to an address outside the enclave given when the enclave is
> > +entered by using the leaf instruction ENCLS(EENTER).
> 
> it's probably a really good idea to explain that the address outside of
> the enclave is enclave-provided, and is not, for instance, just the next
> instruction after EENTER.
> 
> >> Also, for a feature as massive and complicated as this one, it seems
> >> irresponsible to not have a selftest.  Is that not feasible for some reason?
> > 
> > I do have the in-kernel launch enclave stuff backed up here:
> > 
> > https://github.com/jsakkine-intel/sgx-le-host
> > https://github.com/jsakkine-intel/sgx-le
> > 
> > This is about as simple as it gets without any type of run-time.
> 
> Does this code run when I type "make kselftest"?  If not, I think we
> should rectify that.

No, it doesn't. It is just my backup for the non-SDK user space code
that I've made that I will use to fork my user space SGX projects in
the future.

I can work-out a selftest (and provide a new patch in the series) but
I'm still wondering what the enclave should do. I would suggest that
we start with an enclave that does just EEXIT and nothing else.

/Jarkko
