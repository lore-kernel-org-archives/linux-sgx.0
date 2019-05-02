Return-Path: <SRS0=HS12=TC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AB3C43219
	for <linux-sgx@archiver.kernel.org>; Thu,  2 May 2019 08:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5126820873
	for <linux-sgx@archiver.kernel.org>; Thu,  2 May 2019 08:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfEBI2t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 May 2019 04:28:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:63177 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfEBI2s (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 May 2019 04:28:48 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="145369300"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga008.fm.intel.com with ESMTP; 02 May 2019 01:28:44 -0700
Date:   Thu, 2 May 2019 11:28:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v2 2/3] x86/vdso: Modify __vdso_sgx_enter_enclave()
 to allow parameter passing on untrusted stack
Message-ID: <20190502082845.GI14532@linux.intel.com>
References: <cover.1555965327.git.cedric.xing@intel.com>
 <20190424062623.4345-3-cedric.xing@intel.com>
 <20190424190446.GE18442@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E87FD17@ORSMSX116.amr.corp.intel.com>
 <20190426210017.GA24467@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426210017.GA24467@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 26, 2019 at 02:00:18PM -0700, Sean Christopherson wrote:
> On Thu, Apr 25, 2019 at 04:31:40PM -0700, Xing, Cedric wrote:
> > > While this may format nicely in .rst (I haven't checked), it's damn near
> > > unreadable in its raw form.  Escaping '%' in kernel-doc is unresolved at
> > > this point, but this definitely is an argument for allowing the %CONST
> > > interpretation to be disabled entirely.
> > > 
> > 
> > I know very little about kernel-doc. Not quite sure which markup means what.
> > Or if you don't mind, could you just write up the whole thing (you have
> > written half of it in your email already) so I can include it into my next
> > revision?
> 
> Hmm, at this point I'd say just ignore the comment entirely.  It's
> something we need to sort out in the "official" series anyways.

To get started: https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt

/Jarkko
