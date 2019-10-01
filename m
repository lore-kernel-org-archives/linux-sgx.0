Return-Path: <SRS0=+C2n=X2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13159ECE587
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 20:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E44DE20842
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Oct 2019 20:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfJAUkE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Oct 2019 16:40:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:5881 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfJAUkE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Oct 2019 16:40:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 13:40:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,571,1559545200"; 
   d="scan'208";a="185301599"
Received: from nbaca1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.37.57])
  by orsmga008.jf.intel.com with ESMTP; 01 Oct 2019 13:39:54 -0700
Date:   Tue, 1 Oct 2019 23:39:52 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v22 06/24] x86/sgx: Add SGX microarchitectural data
 structures
Message-ID: <20191001203740.GE12699@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-7-jarkko.sakkinen@linux.intel.com>
 <20190927162735.GC23002@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927162735.GC23002@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 27, 2019 at 06:27:35PM +0200, Borislav Petkov wrote:
> > +#define SGX_ATTR_RESERVED_MASK	(BIT_ULL(3) | BIT_ULL(7) | GENMASK_ULL(63, 8))
> 
> Looking how bit 7 is part of the reserved mask but you have it above
> as SGX_ATTR_KSS too. Bit 6, OTOH, is not mentioned anywhere and it
> very much looks like you need to have BIT_ULL(6) above as part of the
> reserved mask instead of bit 7.
> 
> Hmmm?

Correct. This a regression. The reserved bit really should be 6 as
stated in:

  Table 37-3.  Layout of ATTRIBUTES Structure

Thank you.

/Jarkko
