Return-Path: <SRS0=D2+C=54=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FFAC2BA2B
	for <linux-sgx@archiver.kernel.org>; Sun, 12 Apr 2020 14:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5DE5206E9
	for <linux-sgx@archiver.kernel.org>; Sun, 12 Apr 2020 14:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgDLOWX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 12 Apr 2020 10:22:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:14027 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgDLOWX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 12 Apr 2020 10:22:23 -0400
IronPort-SDR: WaVf+CncsG12e2Kbdps/JTAAxdsU5AjAhNOePqWh+ZL2s0q/NghIas2zihuI54D1DurYoGbSve
 vXre3zC9HZ5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2020 07:22:23 -0700
IronPort-SDR: +NsVNSlFfCnwRdoi85LG93LUHyNONJlLPU3aKa+ZQsdD12mlI1Z3AfF1G3CU9iuR3UMsV7Z+8K
 aT2ppt2QV/Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,374,1580803200"; 
   d="scan'208";a="243337971"
Received: from apresura-mobl.ger.corp.intel.com (HELO localhost) ([10.252.61.246])
  by fmsmga007.fm.intel.com with ESMTP; 12 Apr 2020 07:22:22 -0700
Date:   Sun, 12 Apr 2020 17:22:22 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Nikita Sobolev <Nikita.Sobolev@synopsys.com>
Subject: Re: [PATCH] Revert "Kernel selftests: tpm2: check for tpm support"
Message-ID: <20200412142222.GA71710@linux.intel.com>
References: <20200412142005.71348-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412142005.71348-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Apr 12, 2020 at 05:20:05PM +0300, Jarkko Sakkinen wrote:
> This reverts commit b32694cd0724d4ceca2c62cc7c3d3a8d1ffa11fc.
> 
> The original comment was neither reviewed nor tested. Thus, this the
> *only* possible action to take.
> 
> Cc: Nikita Sobolev <Nikita.Sobolev@synopsys.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I've pushed the reverting commit to my master branch, not yet
to next, which mirrors to linux-next.

/Jarkko
