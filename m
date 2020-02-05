Return-Path: <SRS0=YPok=3Z=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB31C35247
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 22:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF4592082E
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Feb 2020 22:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgBEWBa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Feb 2020 17:01:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:48501 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgBEWBa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Feb 2020 17:01:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 14:01:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="404290739"
Received: from gtobin-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.85.85])
  by orsmga005.jf.intel.com with ESMTP; 05 Feb 2020 14:01:24 -0800
Date:   Thu, 6 Feb 2020 00:01:24 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Haitao Huang <haitao.huang@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v25 00/21] Intel SGX foundations
Message-ID: <20200205220124.GC24468@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <op.0fiushlkwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.0fiushlkwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 05, 2020 at 10:01:19AM -0600, Haitao Huang wrote:
> 
> Tested-by: Haitao Huang<haitao.huang@linux.intel.com>

Please point the tested-by to the commit that you are looking at.

You probably want to point it to the driver commit, so please respond to
that instead.

/Jarkko
