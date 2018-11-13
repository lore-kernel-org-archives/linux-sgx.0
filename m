Return-Path: <SRS0=Df3j=NY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C17C43441
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Nov 2018 15:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5490222510
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Nov 2018 15:13:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5490222510
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731687AbeKNBMB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Nov 2018 20:12:01 -0500
Received: from mga18.intel.com ([134.134.136.126]:53210 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbeKNBMA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 13 Nov 2018 20:12:00 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2018 07:13:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,499,1534834800"; 
   d="scan'208";a="280732220"
Received: from ibanaga-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.77])
  by fmsmga006.fm.intel.com with ESMTP; 13 Nov 2018 07:13:18 -0800
Date:   Tue, 13 Nov 2018 17:13:16 +0200
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
Message-ID: <20181113151316.GA3796@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
 <20181106054911.GA15575@linux.intel.com>
 <e7b4c432-7005-308c-4da0-a80e0d294244@intel.com>
 <20181107163019.GA11509@linux.intel.com>
 <914dd171-b48a-12d9-eb77-3c40c8b210cb@intel.com>
 <20181108143942.GA13792@linux.intel.com>
 <20181108192040.GA21685@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181108192040.GA21685@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 08, 2018 at 09:20:40PM +0200, Jarkko Sakkinen wrote:
> On Thu, Nov 08, 2018 at 04:39:42PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 07, 2018 at 09:09:37AM -0800, Dave Hansen wrote:
> > > On 11/7/18 8:30 AM, Jarkko Sakkinen wrote:
> > > >> Does this code run when I type "make kselftest"?  If not, I think we
> > > >> should rectify that.
> > > > No, it doesn't. It is just my backup for the non-SDK user space code
> > > > that I've made that I will use to fork my user space SGX projects in
> > > > the future.
> > > > 
> > > > I can work-out a selftest (and provide a new patch in the series) but
> > > > I'm still wondering what the enclave should do. I would suggest that
> > > > we start with an enclave that does just EEXIT and nothing else.
> > > 
> > > Yeah, that's a start.  But, a good selftest would include things like
> > > faults and error conditions.
> > 
> > Great. We can add more entry points to the enclave for different tests
> > but I'll start with a bare minimum. And yeah but ever goes into next
> > version I'll document the fault handling.
> 
> For the v17 I'll add exactly two test cases:
> 
> 1. EENTER/EEXIT
> 2. EENTER/exception
> 
> So that it will easier to evaluate and demonstrate exception handling.
> 
> /Jarkko

Here is my test program now:

https://github.com/jsakkine-intel/sgx-selftest

It is ~1100 lines ATM. Next I'll deploy it to the kernel tree. It has
only (1) now but I'll add (2) too when I convert this to a kernel patch
(probably by doing sgx_call() with a NULL pointer).

/Jarkko
