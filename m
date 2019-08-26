Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4427C3A59F
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 16:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 816EC2080C
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 16:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732150AbfHZQZi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 12:25:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:51932 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729338AbfHZQZi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 12:25:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 09:25:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="185007395"
Received: from clevorn-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.202])
  by orsmga006.jf.intel.com with ESMTP; 26 Aug 2019 09:25:35 -0700
Date:   Mon, 26 Aug 2019 19:25:33 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Ayoun, Serge" <serge.ayoun@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>
Subject: Re: [PATCH 1/4] x86/sgx: Replace @is_secs_child with @pt in
 sgx_encl_ewb()
Message-ID: <20190826162533.4eojvetcaxhjbmhk@linux.intel.com>
References: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
 <20190823161616.27644-2-jarkko.sakkinen@linux.intel.com>
 <88B7642769729B409B4A93D7C5E0C5E7C6624865@hasmsx108.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88B7642769729B409B4A93D7C5E0C5E7C6624865@hasmsx108.ger.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 26, 2019 at 02:31:54PM +0000, Ayoun, Serge wrote:
> Not sure about this one since this 'if' should never happen, unless there is a bug
> Not clear if the caller (sgx_encl_ewb) will handle -EINVAL properly.
> Maybe would be better to issue some warning message or BUG_ON

The caller issues warning.

/Jarkko
