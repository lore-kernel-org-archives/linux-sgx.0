Return-Path: <SRS0=l2ne=WD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4BAC32754
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 15:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B01D421E73
	for <linux-sgx@archiver.kernel.org>; Wed,  7 Aug 2019 15:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbfHGPR4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 11:17:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:29249 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbfHGPR4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 11:17:56 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 08:17:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,357,1559545200"; 
   d="scan'208";a="373803853"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga005.fm.intel.com with ESMTP; 07 Aug 2019 08:17:50 -0700
Date:   Wed, 7 Aug 2019 18:17:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com
Subject: Re: [PATCH v21 08/28] x86/cpu/intel: Detect SGX support and update
 caps appropriately
Message-ID: <20190807151751.hfhi6x4lope5oipw@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
 <20190713170804.2340-9-jarkko.sakkinen@linux.intel.com>
 <20190724193542.GD25376@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724193542.GD25376@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jul 24, 2019 at 12:35:42PM -0700, Sean Christopherson wrote:
> > +	if (IS_ENABLED(CONFIG_INTEL_SGX) && cpu_has(c, X86_FEATURE_SGX))
> > +		detect_sgx(c);
> > +
> > +	init_intel_energy_perf(c);
> 
> All of the energy_perf additions are bogus, looks like a rebase gone wrong.

Fixed in the master.

/Jarkko
