Return-Path: <SRS0=BFWe=UY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B4DC48BD5
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 15:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEAFB208E3
	for <linux-sgx@archiver.kernel.org>; Tue, 25 Jun 2019 15:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbfFYPnu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 25 Jun 2019 11:43:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:7838 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfFYPnu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 25 Jun 2019 11:43:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 08:43:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,416,1557212400"; 
   d="scan'208";a="152334540"
Received: from pkoeberl-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.33.126])
  by orsmga007.jf.intel.com with ESMTP; 25 Jun 2019 08:43:42 -0700
Date:   Tue, 25 Jun 2019 18:43:41 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v20 22/28] x86/traps: Attempt to fixup exceptions in vDSO
 before signaling
Message-ID: <20190625154341.GA7046@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-23-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417103938.7762-23-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 17, 2019 at 01:39:32PM +0300, Jarkko Sakkinen wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> vDSO functions can now leverage an exception fixup mechanism similar to
> kernel exception fixup.  For vDSO exception fixup, the initial user is
> Intel's Software Guard Extensions (SGX), which will wrap the low-level
> transitions to/from the enclave, i.e. EENTER and ERESUME instructions,
> in a vDSO function and leverage fixup to intercept exceptions that would
> otherwise generate a signal.  This allows the vDSO wrapper to return the
> fault information directly to its caller, obviating the need for SGX
> applications and libraries to juggle signal handlers.
> 
> Attempt to fixup vDSO exceptions immediately prior to populating and
> sending signal information.  Except for the delivery mechanism, an
> exception in a vDSO function should be treated like any other exception
> in userspace, e.g. any fault that is successfully handled by the kernel
> should not be directly visible to userspace.
> 
> Although it's debatable whether or not all exceptions are of interest to
> enclaves, defer to the vDSO fixup to decide whether to do fixup or
> generate a signal.  Future users of vDSO fixup, if there ever are any,
> will undoubtedly have different requirements than SGX enclaves, e.g. the
> fixup vs. signal logic can be made function specific if/when necessary.
> 
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I went through the vDSO changes just to revisit couple of details that I
had forgotten. Sean, if you don't mind I'd squash this and prepending
patch.

Is there any obvious reason why #PF fixup is in its own patch and the
rest are collected to the same patch? I would not find it confusing if
there was one patch per exception but really don't get this division.

/Jarkko
