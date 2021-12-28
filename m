Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B95C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Dec 2021 23:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhL1Xhp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 Dec 2021 18:37:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54110 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhL1Xhp (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 28 Dec 2021 18:37:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 605D1B80E4C
        for <linux-sgx@vger.kernel.org>; Tue, 28 Dec 2021 23:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EBCC36AE9;
        Tue, 28 Dec 2021 23:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640734663;
        bh=q8kHyLlfngowpUSiel0s+aPm5EItkb7zLjA8G/4rBdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDMDfcu887W6T0CSjeI2c4Mzp8zRdU1XAkyQ2tlz1z/GCOWSfjPAfe0Kq9jh5vetK
         HapXHDDunM53E2M786ZCtFG+4Qw1gDUVEqH8TxVCYNjdDMHwQQ2QcoSeV0EXsqcQzo
         ya/2kC+kOyZXyEOXrY/v/yXFB/9Z6ArgL7nTg1MbVRSF7YubfgOBdYd7m7kfMWl2Ep
         QDHIbQdf3ObcStL518Stjk0OQeHLjV4HrigjljHuqYc0wP8Z2L+5wgkTLjQH+MU1Gp
         JNYyVZDmcILi2lxG/GhZUHvXMhu9Q30xQL73A8aTaZ1TYGlInfbAcIjKodbEF8MDmn
         i88IFOFkUcEoA==
Date:   Wed, 29 Dec 2021 01:37:40 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] x86/sgx: account backing pages
Message-ID: <YcufxPNV8HleTPB4@iki.fi>
References: <20211220174640.7542-1-kristen@linux.intel.com>
 <20211220174640.7542-3-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220174640.7542-3-kristen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 20, 2021 at 09:46:40AM -0800, Kristen Carlson Accardi wrote:
> +int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
> +			    struct sgx_backing *backing)
> +{
> +	return sgx_encl_get_backing(encl, page_index, backing);
> +}

Is this wrapping necessary?

Also, there is ambiguous terminology:

1. Local function: "get_backing"
2. Exported function: "lookup_backing"

/Jarkko
