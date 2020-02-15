Return-Path: <SRS0=Eu7F=4D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06935C352A3
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 07:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3CAF206D7
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 07:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbgBOHYK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 15 Feb 2020 02:24:10 -0500
Received: from mga17.intel.com ([192.55.52.151]:35302 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgBOHYK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 15 Feb 2020 02:24:10 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 23:24:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,443,1574150400"; 
   d="scan'208";a="223275594"
Received: from kfinglet-mobl.ger.corp.intel.com (HELO localhost) ([10.252.22.140])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2020 23:24:06 -0800
Date:   Sat, 15 Feb 2020 09:24:06 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200215072406.GA9958@linux.intel.com>
References: <20191010113745.GA12842@linux.intel.com>
 <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
 <20191011181550.GB30935@linux.intel.com>
 <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com>
 <20191017175735.GD20903@linux.intel.com>
 <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 13, 2020 at 03:10:24PM +0100, Jethro Beekman wrote:
> >> There are other scenarios where it's not just the permissions on
> >> /dev/sgx/enclave that are the problem but using the filesystem in general
> >> that is. Maybe you've used seccomp to disable file operations, etc.
> > 
> > Andy and Jarkko, thoughts?
> 
> Folks, any more thoughts on how to resolve the issue that you need to
> call open() for every enclave?

Why is it an issue?

/Jarkko
