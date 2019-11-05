Return-Path: <SRS0=ABp+=Y5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027B4C010A3
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:11:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBFDD21928
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 11:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388654AbfKELLo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Nov 2019 06:11:44 -0500
Received: from mga18.intel.com ([134.134.136.126]:18842 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388494AbfKELLn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 5 Nov 2019 06:11:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 03:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="403317098"
Received: from zpanjkov-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.3.163])
  by fmsmga006.fm.intel.com with ESMTP; 05 Nov 2019 03:11:29 -0800
Date:   Tue, 5 Nov 2019 13:11:22 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191105111057.GA20879@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <20191029092920.GA14494@linux.intel.com>
 <20191030093045.GB12481@linux.intel.com>
 <20191031211252.GC10507@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031211252.GC10507@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Oct 31, 2019 at 11:12:52PM +0200, Jarkko Sakkinen wrote:
> On Wed, Oct 30, 2019 at 02:30:45AM -0700, Sean Christopherson wrote:
> > Why?  The number of pages processed is effectively returned via the params
> > on any error, e.g. wouldn't it be more appropriate to return -ERESTARTSYS?
> > And I don't see any reason to add an arbitrary cap on the number of pages,
> > e.g. SGX plays nice with the scheduler and signals, and restricting the
> > number of EPC pages available to a process via cgroups (returning -ENOMEM)
> > is a better solution for managing EPC.
> 
> Returning -ENOMEM does not tell you from which page to retry.

API should be robust enough to be able to cap the amount of data
processed with or without cgroups like send(), recv(), read() and
write() are and the call pattern for it must be a loop not a single shot
call for any megalomaniac length.

I'll add @count to address this. This output field will contain the
number of bytes actually written instead of overwriting input
parameters, which is a bad practice in anyway.

We don't need to actually cap to anything but API must be able to
support such scenario. Caller must be prepared to deal with the
situation where the return value is zero but @count < @length.

/Jarkko
