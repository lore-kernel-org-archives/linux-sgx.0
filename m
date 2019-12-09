Return-Path: <SRS0=qYOK=Z7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1477C43603
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Dec 2019 19:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC95D2073D
	for <linux-sgx@archiver.kernel.org>; Mon,  9 Dec 2019 19:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLITuO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:50:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:18590 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfLITuO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 9 Dec 2019 14:50:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 11:38:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="244573678"
Received: from nshalmon-mobl.ger.corp.intel.com (HELO localhost) ([10.252.8.146])
  by fmsmga002.fm.intel.com with ESMTP; 09 Dec 2019 11:38:24 -0800
Date:   Mon, 9 Dec 2019 21:38:22 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v24 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191209193822.GB19243@linux.intel.com>
References: <20191129231326.18076-1-jarkko.sakkinen@linux.intel.com>
 <20191129231326.18076-13-jarkko.sakkinen@linux.intel.com>
 <op.0b6gvhtiwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <20191202182102.GF4063@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202182102.GF4063@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 02, 2019 at 10:21:03AM -0800, Sean Christopherson wrote:
> On Mon, Dec 02, 2019 at 09:48:43AM -0600, Haitao Huang wrote:
> > On Fri, 29 Nov 2019 17:13:14 -0600, Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > 
> > 
> > >+
> > >+	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> > >+		if (signal_pending(current)) {
> > >+			ret = -ERESTARTSYS;
> > >+			break;
> > >+		}
> > 
> > This IOC is not idempotent as pages EADDed at this point can not be
> > re-EADDed again. So we can't return ERESTARTSYS
> 
> Ah, and now I remember why I opted for modifying the parameters directly
> instead of including a "number processed" field.  Andy pointed out the
> ERESTARTSYS thing in the original multi-page add RFC[*], so presumably
> updating the params and returning ERESTARTSYS is legal/acceptable.
> 
> [*] https://lkml.kernel.org/r/CALCETrUb4X9_L9RXKhmyNpfSCsbNodP=BfbfO8Fz_efq24jp8w@mail.gmail.com

There are exactly two primary options to pick from given the
non-idempotent nature:

A. Return zero (since we support partial operation with the changes I
   did in v24).
B. Return -EINTR.

If we wanted to follow common syscall semantics in IO operations, then
the semantics would be a mix of these:

1. Return -EINTR if signals are pending before any pages got added.
2. Return 0 if at least one page got added.

This is how write() works for example according to the documentation
[1]. As far as the user code goes [2] I think for that it is best
idea to rely on semantics that developers are used to instead of
being clever here.

[1] http://man7.org/linux/man-pages/man2/write.2.html
[2] https://lkml.kernel.org/r/CALCETrUb4X9_L9RXKhmyNpfSCsbNodP=BfbfO8Fz_efq24jp8w@mail.gmail.com

/Jarkko
