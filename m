Return-Path: <SRS0=L1tv=Y4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B34CA9EC9
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 22:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B01F82084D
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 22:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfKDWhD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 17:37:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:40645 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbfKDWhD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 17:37:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 14:37:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="204763836"
Received: from rczubala-mobl.ger.corp.intel.com (HELO localhost) ([10.252.7.245])
  by orsmga003.jf.intel.com with ESMTP; 04 Nov 2019 14:37:00 -0800
Date:   Tue, 5 Nov 2019 00:36:59 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 3/3] x86/sgx: Remove a subordinate clause
Message-ID: <20191104223636.GC3606@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
 <20191104200141.5385-3-jarkko.sakkinen@linux.intel.com>
 <20191104212122.GC5960@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104212122.GC5960@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 04, 2019 at 01:21:22PM -0800, Sean Christopherson wrote:
> On Mon, Nov 04, 2019 at 10:01:41PM +0200, Jarkko Sakkinen wrote:
> > The subordinate clause of last sentence of the sgx_ioc_enclave_pages()
> > does not provide any insight not already provided. Thus, remove it.
> 
> Isn't the whole point of the documentation to help the user understand
> *how* to use the API, not simply state exactly what the code does?

For kdoc it should explain in clear and concise way

That clause does not provide any help for that. It just repeats with
different vocabulary the exact same thing as was already said.

> > Also, using "i.e." (and "e.g.") in the documentation should be
> > considered a bad practice because it leaves it open ended.
> 
> How does stating the practical effect of the semantics leave the docs open
> ended?  The man pages for open[1], close[2], read[3], dlopen[4], etc...
> all provide examples (usually with "for example" verbiage) to call out
> common scenarios to help the reader understand the details, and close()
> also uses "i.e." to clarify.

I did not find the use of "i.e." or "e.g." from those. When they
introduce an example it is done in a more structured way, not as
a subordinate clause.

/Jarkko
