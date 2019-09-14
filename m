Return-Path: <SRS0=ViI6=XJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FBEC4CEC7
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Sep 2019 12:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD0A820854
	for <linux-sgx@archiver.kernel.org>; Sat, 14 Sep 2019 12:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbfINMWW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 14 Sep 2019 08:22:22 -0400
Received: from mga18.intel.com ([134.134.136.126]:63868 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbfINMWW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 14 Sep 2019 08:22:22 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Sep 2019 05:22:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="337197077"
Received: from krusocki-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.34])
  by orsmga004.jf.intel.com with ESMTP; 14 Sep 2019 05:22:19 -0700
Date:   Sat, 14 Sep 2019 13:22:17 +0100
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: Re: [PATCH 1/2] x86/sgx: Wrap ENCLS[EWB]
Message-ID: <20190914122217.GA6299@linux.intel.com>
References: <20190912193809.29336-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912193809.29336-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 12, 2019 at 08:38:08PM +0100, Jarkko Sakkinen wrote:
> A reclaimed page is represented by two entities:
> 
> 1. A version number in the Enclave Page Cache (EPC). Version numbers are
>    stored in Version Array (VA) pages [1].
> 2. Page contents and MAC [2] encrypted with a random transient key and the
>    version number in the system memory.
> 
> This commit introduces a wrapper function for ENCLS[EWB], which transforms
> a page from EPC to the system memory, resulting the forementioned entities.
> The reason for having struct sgx_ewb_context is that the reclaiming process
> can pin the resources in early phases of the page reclaiming process when a
> clean rollback from a failure (e.g. running out of memory) is still
> possible.

Ignore these. Sent by mistake.

In my tree in for-v23 there is already some alternative patches in
progress on top of my other v23 changes.

/Jarkko
