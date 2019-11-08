Return-Path: <SRS0=KbJW=ZA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F04FC6194
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Nov 2019 08:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33737207FA
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Nov 2019 08:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfKHIUo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:20:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:10567 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbfKHIUo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 8 Nov 2019 03:20:44 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 00:20:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,280,1569308400"; 
   d="scan'208";a="213200201"
Received: from rafalwi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.3.149])
  by fmsmga001.fm.intel.com with ESMTP; 08 Nov 2019 00:20:33 -0800
Date:   Fri, 8 Nov 2019 10:20:31 +0200
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
Message-ID: <20191108082031.GC3370@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <20191029092920.GA14494@linux.intel.com>
 <20191030093045.GB12481@linux.intel.com>
 <20191031211252.GC10507@linux.intel.com>
 <20191105111057.GA20879@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105111057.GA20879@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 05, 2019 at 01:11:22PM +0200, Jarkko Sakkinen wrote:
> I'll add @count to address this. This output field will contain the
> number of bytes actually written instead of overwriting input
> parameters, which is a bad practice in anyway.
> 
> We don't need to actually cap to anything but API must be able to
> support such scenario. Caller must be prepared to deal with the
> situation where the return value is zero but @count < @length.

I summarized here my reasoning on @count:

https://lore.kernel.org/linux-sgx/20191108081331.GB3370@linux.intel.com/

/Jarkko
