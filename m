Return-Path: <SRS0=tSvt=VM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B983C7618F
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jul 2019 09:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 459AC2083D
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jul 2019 09:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbfGOJ3H (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Jul 2019 05:29:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:41918 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729413AbfGOJ3G (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Jul 2019 05:29:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 02:29:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="318626819"
Received: from pertsuli-mobl.ger.corp.intel.com (HELO localhost) ([10.252.36.224])
  by orsmga004.jf.intel.com with ESMTP; 15 Jul 2019 02:29:03 -0700
Date:   Mon, 15 Jul 2019 12:29:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com
Subject: Re: [PATCH] x86/sgx: Return 0 when !CONFIG_INTEL_SGX_DRIVER
Message-ID: <20190715092902.l4gtg6ytog6ckd6d@linux.intel.com>
References: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714143212.971-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jul 14, 2019 at 05:32:12PM +0300, Jarkko Sakkinen wrote:
> When the config option is not enabled the initialization is always
> succesful.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

It would whole a lot simpler if the call was just flagged:

#ifdef CONFIG_INTEL_SGX_DRIVER
	ret = sgx_drv_init();
	if (ret)
		goto err_kthread;
#endif

/Jarkko
