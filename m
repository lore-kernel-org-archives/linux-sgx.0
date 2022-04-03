Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB455C433F5
	for <linux-sgx@archiver.kernel.org>; Sun,  3 Apr 2022 08:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiDCIaH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 3 Apr 2022 04:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiDCIaG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sun, 3 Apr 2022 04:30:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4A529CAD
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 01:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C80EFB80CC5
        for <linux-sgx@vger.kernel.org>; Sun,  3 Apr 2022 08:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7A9C340F3;
        Sun,  3 Apr 2022 08:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648974490;
        bh=x7CW9At5EdRwyNqwKbMMVRKaleDmoFZIvTBPHSWdN4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mA0JOb/6yxxgXH/97+NAhr3/gZoXdChbTZWQUnVNDFOo12vO40rmso1nH6/tIVj1B
         0j0ug0SYZwGhGFdDqmFiYcRhqNXDY9WwMkWl/wXcSFRJ+S5RCE7hUNZ+P1GXndU+2T
         mkjfMqIwEZn62ohsRUndqMrIwkM5ViJUXtOw3iN/xH7IB4j/pArb/qst428nBlyLmy
         0XyboaZ3JEOXEqqXqLEKLGPhDsRQtEvVLPtAPzrkWecHSjzls4suTD5r43nBh7IMzQ
         ejv+cQFAScGqEdBl9zATrbjSqaaaQKhbOcW2fGowwsVSPYON4Oo36+gT0VPG+lc3a0
         psFJPnlp0lmwg==
Date:   Sun, 3 Apr 2022 11:29:19 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com
Subject: Re: [RFC PATCH v3 02/10] x86/sgx: Provide VA page non-NULL owner
Message-ID: <Ykla34zPVGprnmpb@kernel.org>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
 <20220401142409.26215-3-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401142409.26215-3-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 01, 2022 at 10:24:01PM +0800, Cathy Zhang wrote:
> Provide non-NULL owner for VA page, which tells that the EPC page is
> allocated for use.
> 
> Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

So here the code change does not look all that bad but the commit message
completely explanation of it.

"Provided non-NULL owner" is not something that I can map to any reasonable
action that , i.e. I don't know what the heck it even means :-) It's just
jargon, isn't it?

Staart with

"Make epc->owner type-agnostic by changing it's type to `void *`. ..."

Then you should answer exactly two questions in the commit message:

* Who is the owner? For regular pages it's the logical enclave page.
* For exactly what use it is allocated for?

BR, Jarkko

