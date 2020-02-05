Return-Path: <SRS0=YPok=3Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946D6C35247
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 23:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EC262072B
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 23:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgBEXL4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:11:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:11678 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgBEXL4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Feb 2020 18:11:56 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 15:11:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="249875306"
Received: from gtobin-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.85.85])
  by orsmga002.jf.intel.com with ESMTP; 05 Feb 2020 15:11:48 -0800
Date:   Thu, 6 Feb 2020 01:11:47 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH v25 07/21] x86/sgx: Enumerate and track EPC sections
Message-ID: <20200205231147.GD28111@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-8-jarkko.sakkinen@linux.intel.com>
 <20200205195700.GJ4877@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205195700.GJ4877@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 05, 2020 at 11:57:00AM -0800, Sean Christopherson wrote:
> > +		ret = __eremove(sgx_epc_addr(page));
> > +		if (!WARN_ON_ONCE(ret)) {
> 
> Sadly, this WARN can fire after kexec() on systems with multiple EPC
> sections if the SECS has child pages in another section.

What causes this?

/Jarkko
