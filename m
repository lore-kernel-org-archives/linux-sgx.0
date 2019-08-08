Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96755C433FF
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 726522184E
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 15:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbfHHP5L (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 11:57:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:35990 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbfHHP5L (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 11:57:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 08:57:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="199092441"
Received: from sandersb-mobl.ger.corp.intel.com (HELO localhost) ([10.249.33.239])
  by fmsmga004.fm.intel.com with ESMTP; 08 Aug 2019 08:57:08 -0700
Date:   Thu, 8 Aug 2019 18:57:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 00/11] x86/sgx: Bug fixes for v22
Message-ID: <20190808155707.jv2m6ljkl3dmkb5k@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808001254.11926-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 07, 2019 at 05:12:43PM -0700, Sean Christopherson wrote:
> A variety of bug fixes, some for issues reported by Shay, the rest for
> issues found by inspection.  Sent as a bundle because most of the patches
> conflict in one way or another, and so that others can apply on master to
> get a stable build.

Summary (once with A, I'm ready to squash):

https://patchwork.kernel.org/project/intel-sgx/list/?series=156821

Two of unacked patches just need just some minor rework. 4/11 was the
only with some opens at this point.

Thank you to both you and also to Shay who has done marvelous job catching
those regressions.

/Jarkko
