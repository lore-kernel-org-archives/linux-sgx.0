Return-Path: <SRS0=I7Yp=4J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FE8C35647
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 13:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22758206EF
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 13:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgBUNAj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:00:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:26988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgBUNAj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Feb 2020 08:00:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 05:00:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,468,1574150400"; 
   d="scan'208";a="269979621"
Received: from mklimasz-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.87.58])
  by fmsmga002.fm.intel.com with ESMTP; 21 Feb 2020 05:00:32 -0800
Date:   Fri, 21 Feb 2020 15:00:31 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Message-ID: <20200221130009.GB3112@linux.intel.com>
References: <20191017175735.GD20903@linux.intel.com>
 <eaf66973-9c9b-b06c-4b96-134e41c18d80@fortanix.com>
 <20200215072406.GA9958@linux.intel.com>
 <ed49f988-e4e5-b2b9-0108-f489e9b5f449@fortanix.com>
 <20200217185512.GA7677@linux.intel.com>
 <20200218104243.GA13967@wind.enjellic.com>
 <20200218155247.GA18374@linux.intel.com>
 <20200219162640.GA29921@wind.enjellic.com>
 <20200220195537.GA23349@linux.intel.com>
 <20200221011913.GA15165@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221011913.GA15165@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 20, 2020 at 07:19:13PM -0600, Dr. Greg wrote:
> > > This would seem to imply that the driver is rather firmly architected
> > > on the notion of one open() per enclave, a concept that Jethro seems
> > > to have issues with.
> 
> > I don't understand what concept you are talking about.
> 
> If memory serves me correctly, Jethro envisioned a model where a
> single open of the SGX driver node would return a file descriptor that
> could then be used to create/load/initialize multiple enclaves.  Your
> clarifications indicate that a separate open will be needed for each
> and every enclave instance that will be orchestrated.
> 
> Jethro, if I'm mistating your position on this, please jump in and
> clarify.

Ah.

You are speaking about having a factory to create enclaves and a
management interface. I.e. you'd have ioctl to create enclave that gives
you a file descriptor to access its management interface.

Out of top of my head I cannot recall why this was not favored in the
end but generally speaking added complexity should be justified by some
considerably strong measures.

/Jarkko
