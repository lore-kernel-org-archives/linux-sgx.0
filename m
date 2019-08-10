Return-Path: <SRS0=SeXc=WG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DD2C433FF
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 11:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7869D21743
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 11:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfHJLog (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 10 Aug 2019 07:44:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:9790 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfHJLof (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 10 Aug 2019 07:44:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Aug 2019 04:44:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,369,1559545200"; 
   d="scan'208";a="186907291"
Received: from agudipat-mobl.ger.corp.intel.com (HELO localhost) ([10.249.36.164])
  by orsmga002.jf.intel.com with ESMTP; 10 Aug 2019 04:44:32 -0700
Date:   Sat, 10 Aug 2019 14:44:30 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 00/11] x86/sgx: Bug fixes for v22
Message-ID: <20190810114430.ny6pbpmnt5evaafa@linux.intel.com>
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
>   x86/sgx: Require EADD source to be page aligned

Everything else merged expect this.

/Jarkko
