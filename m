Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A9BC3A5A1
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 930AB23404
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 02:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388886AbfHWCGm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 22:06:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:18419 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388815AbfHWCGm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 22:06:42 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 19:06:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="330581284"
Received: from nmordaws-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.129])
  by orsmga004.jf.intel.com with ESMTP; 22 Aug 2019 19:06:39 -0700
Date:   Fri, 23 Aug 2019 05:06:37 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Subject: Re: CONFIG_INTEL_SGX_DRIVER removed
Message-ID: <20190823020637.qswfhriczgcj22vk@linux.intel.com>
References: <20190823020445.rmw5yx7457twzfr2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823020445.rmw5yx7457twzfr2@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 05:04:45AM +0300, Jarkko Sakkinen wrote:
> CONFIG_INTEL_SGX_DRIVER has been now removed based on the conclusions
> that core cannot exist in vmlinux without the driver. I also flattened
> the hierarchy like I said I would.

The driver commit message needs a full rewite. I already wrote one but
unfortunately I accidently quit my text editor and lost it. The current
one is completely out of date.

/Jarkko
