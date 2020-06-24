Return-Path: <SRS0=YYkI=AF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9EFC433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 23:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79C2920672
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Jun 2020 23:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388014AbgFXXyI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Jun 2020 19:54:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:6245 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387981AbgFXXyI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Jun 2020 19:54:08 -0400
IronPort-SDR: iLm/Z6E0vyzLKmzXC8Wedo8Hc2gjVKzUX0YxclKNCpbJ1Pg12hles5ONsQSQKCEcTIs5IKBkaw
 cG5KaFLN/K/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="146176743"
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="146176743"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 16:54:07 -0700
IronPort-SDR: 9qhSF0RMX84lA7HrRL015H2icfbe8nRdYCNqVgJAYK6qc4jWaaoGCW4jODCwVpVJjX3c4cc6Fb
 SvJOq9MRJ0mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="423544402"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga004.jf.intel.com with ESMTP; 24 Jun 2020 16:54:07 -0700
Date:   Wed, 24 Jun 2020 16:54:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-sgx@vger.kernel.org, kai.svahn@intel.com,
        bruce.schlobohm@intel.com
Subject: Re: [PATCH RFC] x86/sgx: Allocate form local NUMA node first
Message-ID: <20200624235406.GH25092@linux.intel.com>
References: <20200623043931.157156-1-jarkko.sakkinen@linux.intel.com>
 <57c83d3d-54ab-fc07-cefc-c3ebe478a8e9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57c83d3d-54ab-fc07-cefc-c3ebe478a8e9@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 24, 2020 at 04:24:25PM -0700, Dave Hansen wrote:
> On 6/22/20 9:39 PM, Jarkko Sakkinen wrote:
> > +static int __init sgx_pfn_to_nid(unsigned long pfn)
> > +{
> > +	pg_data_t *pgdat;
> > +	int nid;
> > +
> > +	for (nid = 0; nid < nr_node_ids; nid++) {
> > +		pgdat = NODE_DATA(nid);
> > +
> > +		if (pfn >= pgdat->node_start_pfn &&
> > +		    pfn < (pgdat->node_start_pfn + pgdat->node_spanned_pages))
> 
> pgdat_end_pfn(), perhaps?
> 
> > +			return nid;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Does this actually work?
> 
> The node span (->node_start_pfn through start+->node_spanned_pages) only
> contains pages which the OS is actively managing, usually RAM but
> sometimes also persistent memory.  This has some assumption that the SGX
> PFNs are within the node's span.  I would only _expect_ that to happen
> if the node was built like this:
> 
> 	| Node-X RAM | EPC | Node-X RAM |
> 
> If the EPC was on either end:
> 
> 	| Node-X RAM | EPC |
> or
> 	| EPC | Node-X RAM |
> 
> I suspect that the pgdat span wouldn't include EPC.  EPC is, if I
> remember correctly, a E820_RESERVED region.

It is indeed E820_RESERVED, but the BIOS WG for ICX states that EPC regions
should be enumerated in ACPI SRAT along with regular memory.

But, I haven't actually verified that info makes its way into the kernel's
pgdata stuff.
