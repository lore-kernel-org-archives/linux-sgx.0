Return-Path: <SRS0=tPzl=NT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862ABECDE4B
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 14:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A2892081D
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Nov 2018 14:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A2892081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbeKIAPl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:15:41 -0500
Received: from mga05.intel.com ([192.55.52.43]:26962 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbeKIAPl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Nov 2018 19:15:41 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2018 06:39:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,480,1534834800"; 
   d="scan'208";a="89586000"
Received: from ibanaga-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.75])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2018 06:39:44 -0800
Date:   Thu, 8 Nov 2018 16:39:42 +0200
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
Message-ID: <20181108143942.GA13792@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
 <20181106054911.GA15575@linux.intel.com>
 <e7b4c432-7005-308c-4da0-a80e0d294244@intel.com>
 <20181107163019.GA11509@linux.intel.com>
 <914dd171-b48a-12d9-eb77-3c40c8b210cb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <914dd171-b48a-12d9-eb77-3c40c8b210cb@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181108143942.Sen4cpMNtMLlym8dIgTdIcpZ3CqHk81sHJSsJib25MQ@z>

On Wed, Nov 07, 2018 at 09:09:37AM -0800, Dave Hansen wrote:
> On 11/7/18 8:30 AM, Jarkko Sakkinen wrote:
> >> Does this code run when I type "make kselftest"?  If not, I think we
> >> should rectify that.
> > No, it doesn't. It is just my backup for the non-SDK user space code
> > that I've made that I will use to fork my user space SGX projects in
> > the future.
> > 
> > I can work-out a selftest (and provide a new patch in the series) but
> > I'm still wondering what the enclave should do. I would suggest that
> > we start with an enclave that does just EEXIT and nothing else.
> 
> Yeah, that's a start.  But, a good selftest would include things like
> faults and error conditions.

Great. We can add more entry points to the enclave for different tests
but I'll start with a bare minimum. And yeah but ever goes into next
version I'll document the fault handling.

/Jarkko
