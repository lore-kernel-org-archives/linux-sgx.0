Return-Path: <SRS0=YYkI=AF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFB6C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 23:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAFB22073E
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 23:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgFXXMF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Jun 2020 19:12:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:30009 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgFXXME (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Jun 2020 19:12:04 -0400
IronPort-SDR: WVnum1ZacE0u74iDOQ27x0YvjOPCIBqSY41mJGvCVbckOYVF+/W21Adlk9+rhOI3rYiDCtcsX4
 Gp3Vzovdcalg==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="124913672"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="124913672"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 16:12:04 -0700
IronPort-SDR: Zmn9Y2hMtCkdpbWyDRkWlWlVM/7iG3RhIaWw9i75c56bDLvZ+2J3HRalKRdyujkkn2jo9LAxz8
 lIVXhR+7OGvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="293956802"
Received: from hluxenbu-mobl.ger.corp.intel.com (HELO localhost) ([10.252.36.218])
  by orsmga007.jf.intel.com with ESMTP; 24 Jun 2020 16:12:01 -0700
Date:   Thu, 25 Jun 2020 02:12:00 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     kai.svahn@intel.com, bruce.schlobohm@intel.com,
        Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH RFC] x86/sgx: Allocate form local NUMA node first
Message-ID: <20200624231200.GA21758@linux.intel.com>
References: <20200623043931.157156-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623043931.157156-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 23, 2020 at 07:39:31AM +0300, Jarkko Sakkinen wrote:
> Create a pointer array for each NUMA node with the references to the
> contained EPC sections. Use this in __sgx_alloc_epc_page() to knock the
> current NUMA node before the others.
> 
> Cc: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I took a reverse approach, i.e. have only pointer arrays in the numa
structs.

I think we should just include this. It makes the overall structure
more legit, meaning that we do something useful with the sections.

It clarifies more than dissolves so to speak...

/Jarkko
