Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC64BEB64DC
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jul 2023 18:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjGQSyc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGQSyb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 17 Jul 2023 14:54:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FB8AF;
        Mon, 17 Jul 2023 11:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DBEC611FA;
        Mon, 17 Jul 2023 18:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98ACC433C8;
        Mon, 17 Jul 2023 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689620069;
        bh=q+CcNVl9ZK0cZRphlH+tN9jd04M5p/miQtRA2ElEBsU=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=ktJeS+cHTxlzonx3I5NhFdz44aEbFyt4moAWzJ/xyTixlK81r49P+/KpqfCxc2nog
         DQjShDwkHsNozKNPxjEJU/Umik3h5AOdo59idivQja3gRd7rBx7Q5NDtArgonkvKZt
         EZ4xHDvZf5eGYTxqxDMbVCiIsDzYn6chbL4WONZTfqo7M8IgmnrFoNDrEadhP549eQ
         zBE0HyYXv7/0etwPpYng678PDnNS/DM+76+JqQhf0rbuVA5MKmDR1UQAHErYw0w5xD
         RrXRoVnkUUK+6fLjaKg/jepaM4sjEd/MTxV2InoetMAQqfxHyH34XOfWIxUsDMo3SZ
         dcll1Rt6W/89w==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 17 Jul 2023 18:54:24 +0000
Message-Id: <CU4OBQ8MQ2LK.2GRBPLQGVTZ3@seitikki>
Cc:     <kai.huang@intel.com>, <reinette.chatre@intel.com>,
        <kristen@linux.intel.com>, <seanjc@google.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: fix a NULL pointer
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Jarkko Sakkinen" <jarkko@kernel.org>,
        "Haitao Huang" <haitao.huang@linux.intel.com>,
        <dave.hansen@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-sgx@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: aerc 0.14.0
References: <20230717181732.84039-1-haitao.huang@linux.intel.com>
 <CU4OB1RHGF50.1X9C9BVY4XM42@seitikki>
In-Reply-To: <CU4OB1RHGF50.1X9C9BVY4XM42@seitikki>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon Jul 17, 2023 at 6:53 PM UTC, Jarkko Sakkinen wrote:
> On Mon Jul 17, 2023 at 6:17 PM UTC, Haitao Huang wrote:
> > +static struct sgx_epc_page *sgx_encl_load_secs(struct sgx_encl *encl)
> > +{
> > +	struct sgx_epc_page *epc_page =3D encl->secs.epc_page;
> > +
> > +	if (!epc_page) {
> > +		epc_page =3D sgx_encl_eldu(&encl->secs, NULL);
> > +	}
>
> remove curly braces

And add an empty line before the return statement.

BR, Jarkko
