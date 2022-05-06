Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F266C433EF
	for <linux-sgx@archiver.kernel.org>; Fri,  6 May 2022 22:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444755AbiEFW3U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 May 2022 18:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444772AbiEFW3P (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 6 May 2022 18:29:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F61C765F
        for <linux-sgx@vger.kernel.org>; Fri,  6 May 2022 15:25:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1BCBB839E6
        for <linux-sgx@vger.kernel.org>; Fri,  6 May 2022 22:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF10C385A9;
        Fri,  6 May 2022 22:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651875926;
        bh=vNT4ISPU4ZqbS/gZlyHb1iWNLvWXtDbwr9rWrUoLKck=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F1K/an4HNVfCgZLL+Z7mFH+Ve8oZXWhYCgsTvIrhKH+nwK9O6NGrHaahOHwGX5x0h
         yUG/au3b54GwDzFRJGc1Jh3xv4qI4BJyOSMUyjEhFFG/G86wpJtL3Fi29Rp/0ttrW8
         x9rK7Wnctr6sZgTImH6+aFGXZEhYPBHboCXlzQ+kkXcNx42m/rRZ/z5ys/bMqJU2NT
         jvJsEKJPXfkSg9M3JpPqMuhYERgqHW9JdyKVQgfWbiB8ueQBZfk5aRKZHAgReDVM16
         fl/ymhQjWAJ5+hrD8g0u4TZDj614JIo8hHnDD5oMbU+AdGmbPOCTcrVxsPZoKmVll6
         320FhAIUlHXfA==
Message-ID: <de2e1a1d69331bb521222eb93b5ffa6d00af354c.camel@kernel.org>
Subject: Re: [RFC PATCH 2/4] x86/sgx: Set dirty bit after modifying page
 contents
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Date:   Sat, 07 May 2022 01:27:00 +0300
In-Reply-To: <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
         <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2022-04-28 at 13:11 -0700, Reinette Chatre wrote:
> Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
> after faulting the enclave page") expanded __sgx_encl_eldu()
> to clear an enclave page's PCMD (Paging Crypto MetaData)
> from the PCMD page in the backing store after the enclave
> page is restored to the enclave.
>=20
> Since the PCMD page in the backing store is modified the page
> should be set as dirty when releasing the reference to
> ensure the modified data is retained.
>=20
> Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enc=
lave page")
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> =C2=A0arch/x86/kernel/cpu/sgx/encl.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index e5d2661800ac..e03f124ce772 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -98,7 +98,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_p=
age,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kunmap_atomic(pcmd_page);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kunmap_atomic((void *)(un=
signed long)pginfo.contents);
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_encl_put_backing(&b, false=
);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_encl_put_backing(&b, true)=
;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sgx_encl_truncate_backing=
_page(encl, page_index);
> =C2=A0

So, the implementation is:

void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write)
{
	if (do_write) {
		set_page_dirty(backing->pcmd);
		set_page_dirty(backing->contents);
	}

	put_page(backing->pcmd);
	put_page(backing->contents);
}

And we only want to set dirty for PCMD part, right?

Thus, perhaps we should fix it instead by:

	set_page_dirty(backing->pcmd);
	put_page(backing->pcmd):
	put_page(backing->contents);
=09
?=09

I would not mind getting rid of that function anyway. It's kind
of bad wrapping IMHO.
=09
BR, Jarkko
