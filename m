Return-Path: <SRS0=YPok=3Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BA1EC35247
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 23:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A532072B
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 23:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgBEXJR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:09:17 -0500
Received: from mga12.intel.com ([192.55.52.136]:3119 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgBEXJQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Feb 2020 18:09:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 15:09:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="249874692"
Received: from gtobin-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.85.85])
  by orsmga002.jf.intel.com with ESMTP; 05 Feb 2020 15:09:10 -0800
Date:   Thu, 6 Feb 2020 01:09:09 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v25 00/21] Intel SGX foundations
Message-ID: <20200205230909.GC28111@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204151143.GA5663@linux.intel.com>
 <20200205215910.GB24468@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205215910.GB24468@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 05, 2020 at 11:59:10PM +0200, Jarkko Sakkinen wrote:
> > Missing the MAINTAINERS update.
> 
> That was not intended.

Added back.

/Jarkko
