Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876A3C433DF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 01:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EB21207D5
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 01:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgFABCQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 May 2020 21:02:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:29392 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgFABCP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 May 2020 21:02:15 -0400
IronPort-SDR: AIkMu2A9F15OoUvVcwT6jwWBAInMbyow0EdWZuJ4YXlK9FfLHx1MVKFEb/Rkl6q9OrJdr/qMof
 h2hlMljsDOtw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 17:59:15 -0700
IronPort-SDR: LYaO35Vg0ODd4/s6aL5w/xzdZsdz4vslfjQpuHhrAUOp+rBgaJ2DIR17WjY8Afck8iSqTPQPBp
 mmOspAbw3o+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,458,1583222400"; 
   d="scan'208";a="470114916"
Received: from hbetts-mobl.ger.corp.intel.com (HELO localhost) ([10.252.59.178])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2020 17:59:13 -0700
Date:   Mon, 1 Jun 2020 03:59:12 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v31 5/6] x86/sgx: Update stale comment in EPC page
 allocators
Message-ID: <20200601005912.GC660229@linux.intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
 <20200529175407.2109-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529175407.2109-6-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 29, 2020 at 10:54:06AM -0700, Sean Christopherson wrote:
> Replace "Grab" with "Allocate" in the function comments for the EPC page
> allocators.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Neither can apply this to anything.

/Jarkko
