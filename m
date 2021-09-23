Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C921AC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6D361241
	for <linux-sgx@archiver.kernel.org>; Thu, 23 Sep 2021 20:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242529AbhIWU0K (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 Sep 2021 16:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243176AbhIWU0J (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 Sep 2021 16:26:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60C9261019;
        Thu, 23 Sep 2021 20:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632428677;
        bh=VJuk4qOugp/PBTKhpxKvn3xlj71fmDCra8ID0jiZnKo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SvYoI/z5W2U2Dup4XBA9OUa7m2TLb05D/VQR0ue9cunvg9LSuId0joL4mxNTj3+PB
         mJYp54SpCHeUrAmDp8kh2C6q9rAydey8cWOqLtJE/glPOxZbEFfwhoE7MxIZdIsZu2
         JC9pTY7xZ0OYxtriVYGFDj4xj3isaFiTu/z/T641up16SnVYSiLf5rcesHVTpo1XHI
         VWfWlmjX9H63kUhnHzaqKa5WL6lUq5LZrEmfyViZD+1HsxN7wQsFbWaLezI4H7A4wD
         VW7a1VcovJPoDzgktLs92SMgyhWXDI8xtzQc3M+qtvobwghWMU1u470F+47jhj5py2
         XSv06jeTxJNlw==
Message-ID: <42f4b668b5abe818295d804d43c077e5d3cb4a4c.camel@kernel.org>
Subject: Re: [PATCH v6 1/7] x86/sgx: Provide indication of life-cycle of EPC
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org
Date:   Thu, 23 Sep 2021 23:24:35 +0300
In-Reply-To: <5aa9e385b38ce0f63d6b531ede2baafd17fc7861.camel@kernel.org>
References: <20210917213836.175138-1-tony.luck@intel.com>
         <20210922182123.200105-1-tony.luck@intel.com>
         <20210922182123.200105-2-tony.luck@intel.com>
         <5aa9e385b38ce0f63d6b531ede2baafd17fc7861.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2021-09-23 at 23:21 +0300, Jarkko Sakkinen wrote:
> On Wed, 2021-09-22 at 11:21 -0700, Tony Luck wrote:
> > SGX EPC pages go through the following life cycle:
> >=20
> >         DIRTY ---> FREE ---> IN-USE --\
> >                     ^                 |
> >                     \-----------------/
> >=20
> > Recovery action for poison for a DIRTY or FREE page is simple. Just
> > make sure never to allocate the page. IN-USE pages need some extra
> > handling.
> >=20
> > It would be good to use the sgx_epc_page->owner field as an indicator
> > of where an EPC page is currently in that cycle (owner !=3D NULL means
> > the EPC page is IN-USE). But there is one caller, sgx_alloc_va_page(),
> > that calls with NULL.
> >=20
> > Since there are multiple uses of the "owner" field with different types
> > change the type of sgx_epc_page.owner to "void *.
> >=20
> > Start epc_pages out with a non-NULL owner while they are in DIRTY state=
.
> >=20
> > Fix up the one holdout to provide a non-NULL owner.
> >=20
> > Refactor the allocation sequence so that changes to/from NULL
> > value happen together with adding/removing the epc_page from
> > a free list while the node->lock is held.
> >=20
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c  |  5 +++--
> >  arch/x86/kernel/cpu/sgx/encl.h  |  2 +-
> >  arch/x86/kernel/cpu/sgx/ioctl.c |  2 +-
> >  arch/x86/kernel/cpu/sgx/main.c  | 21 +++++++++++----------
> >  arch/x86/kernel/cpu/sgx/sgx.h   |  4 ++--
> >  5 files changed, 18 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/e=
ncl.c
> > index 001808e3901c..62cf20d5fbf6 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -667,6 +667,7 @@ int sgx_encl_test_and_clear_young(struct mm_struct =
*mm,
> > =20
> >  /**
> >   * sgx_alloc_va_page() - Allocate a Version Array (VA) page
> > + * @owner:	struct sgx_va_page connected to this VA page
> >   *
> >   * Allocate a free EPC page and convert it to a Version Array (VA) pag=
e.
> >   *
> > @@ -674,12 +675,12 @@ int sgx_encl_test_and_clear_young(struct mm_struc=
t *mm,
> >   *   a VA page,
> >   *   -errno otherwise
> >   */
> > -struct sgx_epc_page *sgx_alloc_va_page(void)
> > +struct sgx_epc_page *sgx_alloc_va_page(void *owner)
> >  {
> >  	struct sgx_epc_page *epc_page;
> >  	int ret;
> > =20
> > -	epc_page =3D sgx_alloc_epc_page(NULL, true);
> > +	epc_page =3D sgx_alloc_epc_page(owner, true);
> >  	if (IS_ERR(epc_page))
> >  		return ERR_CAST(epc_page);
> > =20
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/e=
ncl.h
> > index fec43ca65065..2a972bc9b2d1 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.h
> > +++ b/arch/x86/kernel/cpu/sgx/encl.h
> > @@ -111,7 +111,7 @@ void sgx_encl_put_backing(struct sgx_backing *backi=
ng, bool do_write);
> >  int sgx_encl_test_and_clear_young(struct mm_struct *mm,
> >  				  struct sgx_encl_page *page);
> > =20
> > -struct sgx_epc_page *sgx_alloc_va_page(void);
> > +struct sgx_epc_page *sgx_alloc_va_page(void *owner);
> >  unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
> >  void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset=
);
> >  bool sgx_va_page_full(struct sgx_va_page *va_page);
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/=
ioctl.c
> > index 83df20e3e633..655ce0bb069d 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -30,7 +30,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_e=
ncl *encl)
> >  		if (!va_page)
> >  			return ERR_PTR(-ENOMEM);
> > =20
> > -		va_page->epc_page =3D sgx_alloc_va_page();
> > +		va_page->epc_page =3D sgx_alloc_va_page(va_page);
> >  		if (IS_ERR(va_page->epc_page)) {
> >  			err =3D ERR_CAST(va_page->epc_page);
> >  			kfree(va_page);
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/m=
ain.c
> > index 63d3de02bbcc..69743709ec90 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -457,7 +457,7 @@ static bool __init sgx_page_reclaimer_init(void)
> >  	return true;
> >  }
> > =20
> > -static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
> > +static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(void *owner=
, int nid)
> >  {
> >  	struct sgx_numa_node *node =3D &sgx_numa_nodes[nid];
> >  	struct sgx_epc_page *page =3D NULL;
> > @@ -471,6 +471,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_fr=
om_node(int nid)
> > =20
> >  	page =3D list_first_entry(&node->free_page_list, struct sgx_epc_page,=
 list);
> >  	list_del_init(&page->list);
> > +	page->owner =3D owner;
> >  	sgx_nr_free_pages--;
> > =20
> >  	spin_unlock(&node->lock);
> > @@ -480,6 +481,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_fr=
om_node(int nid)
> > =20
> >  /**
> >   * __sgx_alloc_epc_page() - Allocate an EPC page
> > + * @owner:	the owner of the EPC page
> >   *
> >   * Iterate through NUMA nodes and reserve ia free EPC page to the call=
er. Start
> >   * from the NUMA node, where the caller is executing.
> > @@ -488,14 +490,14 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_=
from_node(int nid)
> >   * - an EPC page:	A borrowed EPC pages were available.
> >   * - NULL:		Out of EPC pages.
> >   */
> > -struct sgx_epc_page *__sgx_alloc_epc_page(void)
> > +struct sgx_epc_page *__sgx_alloc_epc_page(void *owner)
> >  {
> >  	struct sgx_epc_page *page;
> >  	int nid_of_current =3D numa_node_id();
> >  	int nid =3D nid_of_current;
> > =20
> >  	if (node_isset(nid_of_current, sgx_numa_mask)) {
> > -		page =3D __sgx_alloc_epc_page_from_node(nid_of_current);
> > +		page =3D __sgx_alloc_epc_page_from_node(owner, nid_of_current);
> >  		if (page)
> >  			return page;
> >  	}
> > @@ -506,7 +508,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
> >  		if (nid =3D=3D nid_of_current)
> >  			break;
> > =20
> > -		page =3D __sgx_alloc_epc_page_from_node(nid);
> > +		page =3D __sgx_alloc_epc_page_from_node(owner, nid);
> >  		if (page)
> >  			return page;
> >  	}
> > @@ -559,7 +561,7 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page=
 *page)
> > =20
> >  /**
> >   * sgx_alloc_epc_page() - Allocate an EPC page
> > - * @owner:	the owner of the EPC page
> > + * @owner:	per-caller page owner
> >   * @reclaim:	reclaim pages if necessary
> >   *
> >   * Iterate through EPC sections and borrow a free EPC page to the call=
er. When a
> > @@ -579,11 +581,9 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owne=
r, bool reclaim)
> >  	struct sgx_epc_page *page;
> > =20
> >  	for ( ; ; ) {
> > -		page =3D __sgx_alloc_epc_page();
> > -		if (!IS_ERR(page)) {
> > -			page->owner =3D owner;
> > +		page =3D __sgx_alloc_epc_page(owner);
> > +		if (!IS_ERR(page))
> >  			break;
> > -		}
> > =20
> >  		if (list_empty(&sgx_active_page_list))
> >  			return ERR_PTR(-ENOMEM);
> > @@ -624,6 +624,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
> > =20
> >  	spin_lock(&node->lock);
> > =20
> > +	page->owner =3D NULL;
> >  	list_add_tail(&page->list, &node->free_page_list);
> >  	sgx_nr_free_pages++;
> > =20
> > @@ -652,7 +653,7 @@ static bool __init sgx_setup_epc_section(u64 phys_a=
ddr, u64 size,
> >  	for (i =3D 0; i < nr_pages; i++) {
> >  		section->pages[i].section =3D index;
> >  		section->pages[i].flags =3D 0;
> > -		section->pages[i].owner =3D NULL;
> > +		section->pages[i].owner =3D (void *)-1;
>=20
> Probably should have a named constant.
>=20
> Anyway, I wonder why we want to do tricks with 'owner', when the
> struct has a flags field?
>=20
> Right now its use is so nice and straight forward, and most
> importantly intuitive.
>=20
> So what I would do instead of this, would be to add something
> like
>=20
> /* Pages, which are being tracked by the page reclaimer. */
> #define SGX_EPC_PAGE_RECLAIMER_TRACKED	BIT(0)
>=20
> /* Pages, which are allocated for use. */
> #define SGX_EPC_PAGE_ALLOCATED		BIT(1)
>=20
> This would be set by sgx_alloc_epc_page() and reset by
> sgx_free_epc_page().
>=20
> In the subsequent patch you could then instead of
>=20
>        /*
>         * If there is no owner, then the page is on a free list.
>         * Move it to the poison page list.
>         */
>        if (!page->owner) {
>                list_del(&page->list);
>                list_add(&page->list, &sgx_poison_page_list);
>                goto out;
>        }
>=20
> you would
>=20
>        /*
>         * If there is no owner, then the page is on a free list.
>         * Move it to the poison page list.
>         */
>        if (!page->flags) {
>                list_del(&page->list);
>                list_add(&page->list, &sgx_poison_page_list);
>                goto out;
>        }
>=20
> You don't actually need to compare to that flag because the
> invariant would be that it is set, as long as the page is
> not explicitly freed.
>=20
> I think this is a better solution than in the patch set
> because it does not introduce any unorthodox use of anything.

And does not contain any special cases, e.g. when you debug
something you can always assume that a valid owner pointer is
always a legit sgx_encl_page instance.

/Jarkko
